//
//  HGoToSupport.m
//  Camera360
//
//  Created by zhangchutian on 14-4-3.
//  Copyright (c) 2014年 Pinguo. All rights reserved.
//

#import "HGoTo.h"
#import <Hodor/NSObject+annotation.h>
#import "HGotoRuntimeSupport.h"
#import <Hodor/NSString+ext.h>
#import <Hodor/NSError+ext.h>
#import <Hodor/HDefines.h>
#import <NSURL+ext.h>


@interface HGoto ()
@property (nonatomic, readwrite) id<HGotoConfig> config;
@property (nonatomic) NSMutableDictionary *pasteboard;
@property (nonatomic, weak) UIViewController *autoRoutedVC;
@end


@implementation HGoto

+ (instancetype)center
{
    static dispatch_once_t pred;
    static HGoto *o = nil;
    
    dispatch_once(&pred, ^{
        o = [HGoto new];
    });
    return o;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _config = HProtocalInstance(HGotoConfig);
        NSAssert(_config, @"没找到配置类,请实现配置类,并使用HRegForProtocal注册");
        _pasteboard = [NSMutableDictionary new];
    }
    return self;
}

- (id)route:(NSString *)path doJump:(BOOL)doJump finish:(finish_callback)finish
{
    NSURL *url = [NSURL URLWithString:path];
    if (!url) return nil;
    NSString *schema = url.scheme.lowercaseString;
    if ([schema isEqualToString:@"http"] || [schema isEqualToString:@"https"])
    {
        if ([self.config respondsToSelector:@selector(openHttpURL:)])
        {
            [self.config openHttpURL:path];
        }
        return nil;
    }
    else if ([schema isEqualToString:self.config.appSchema] || [[schema stringByAppendingString:@"://"] isEqualToString:self.config.appSchema.lowercaseString]) {
        NSDictionary *params = [url parameterMap];
        @weakify(self)
        return [self routeWithURL:url params:params doJump:doJump finish:^(id sender, id data, NSError *error) {
            @strongify(self)
            if (error)
            {
                if (finish) finish(sender, data, error);
            }
            else
            {
                NSString *next = params[HGotoKeyword_Next];
                if (next)
                {
                    if (data) [self.pasteboard setObject:data forKey:HGotoPreStepDataKey];
                    [self route:next doJump:doJump finish:finish];
                }
                else
                {
                    if (finish) finish(sender, data, error);
                }
            }
        }];
    }
    else
    {
        if (finish)
        {
            finish(self, nil, herr(kDataFormatErrorCode, ([NSString stringWithFormat:@"wrong protocal only support %@",self.config.appSchema])));
        }
        return nil;
    }
    
}
- (id)routeWithURL:(NSURL *)url params:(NSDictionary *)params doJump:(BOOL)doJump finish:(finish_callback)finish
{
    //搜索全局节点
    NSString *nodeName = url.host;
    if (url.path) nodeName = [nodeName stringByAppendingString:url.path];
    NSString *nodeRegName = [NSString stringWithFormat:@"%@_%@",HGOTO_NODE_REG_PREFIX,nodeName];
    __block NSString *className = nil;
    __block NSArray *options = nil;
    [HClassManager scanClassNameForKey:nodeRegName fetchblock:^(NSString *aclassName, id userInfo) {
        NSAssert(className == nil, @"存在多个路径注册点");
        className = aclassName;
        options = userInfo;
    }];
    if (!className)
    {
        NSAssert(NO, @"没找到对应的注册路径点");
        if (finish) finish(self, nil, herr(kDataFormatErrorCode, ([NSString stringWithFormat:@"没找到对应的注册路径点 %@",nodeName])));
        return nil;
    }
    
    Class klass = NSClassFromString(className);
    
    if (!klass)
    {
        NSAssert(NO, @"无法初始化类");
        if (finish) finish(self, nil, herr(kDataFormatErrorCode, ([NSString stringWithFormat:@"无法初始化类 %@", className])));
        return nil;
    }
    
    //应用选项
    self.autoRoutedVC = [self applyOptions:options doJump:doJump targetClass:klass params:params];
    
    
    //模式1 +[xxClass hgoto_p1:(NSString *)p1 p2:(NSString *)p2 p3:(NSString *)p3 finish:(finish_callback)finish]
    //模式1 +[xxClass hgoto_P1:(NSString *)p1 p2:(NSString *)p2 p3:(NSString *)p3]
    //模式2 +[xxClass hgotoWithParams:(NSDictionary *)paramMap finish:(finish_callback)finish]
    //模式2 +[xxClass hgotoWithParams:(NSDictionary *)paramMap]
    //模式3 +[xxClass hgoto:(NSString *)params finish:(finish_callback)finish]
    //模式3 +[xxClass hgoto:(NSString *)params]
    //模式4 +[xxClass hgotoWithFinish:(finish_callback)finish]
    //模式4 +[xxClass hgoto]
    
    static NSString *methodMode1Prefix = @"hgoto_";
    static NSString *methodMode2Prefix = @"hgotoWithParams:";
    static NSString *methodMode3Prefix = @"hgoto:";
    

    NSArray *classMethods = [NSObject hClassMethodNames:klass];
    //模式1
    NSString *modeMethod1 = nil;
    for (NSString *methodName in classMethods)
    {
        if ([methodName hasPrefix:methodMode1Prefix])
        {
            modeMethod1 = methodName;
            break;
        }
    }
    if (modeMethod1)
    {
        NSString *recverParamsString = [modeMethod1 substringFromIndex:methodMode1Prefix.length];
        NSArray *comp = [recverParamsString componentsSeparatedByString:@":"];
        NSMutableArray *recverParamsArray = [NSMutableArray new];
        for (NSString *str in comp)
        {
            if (str.length == 0) continue;
            [recverParamsArray addObject:str];
        }
        
        SEL modeSelector = NSSelectorFromString(modeMethod1);
        NSMethodSignature * sig = [klass methodSignatureForSelector:modeSelector];
        NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:sig];
        [invocation setTarget:klass];
        [invocation setSelector:modeSelector];
        //if it has params
        if (sig.numberOfArguments > 2)
        {
            int i = 2;
            for (NSString *paramKey in recverParamsArray)
            {
                id value = params[paramKey];
                if ([paramKey isEqualToString:@"finish"])
                {
                    [invocation setArgument:&finish atIndex:i];
                }
                else
                {
                    [invocation setArgument:&value atIndex:i];
                }
                i ++;
            }
        }
        [invocation invoke];
    }
    else
    {
        //模式2
        NSString *modeMethod2 = nil;
        for (NSString *methodName in classMethods)
        {
            if ([methodName hasPrefix:methodMode2Prefix])
            {
                modeMethod2 = methodName;
                break;
            }
        }
        if (modeMethod2)
        {
            SEL modeSelector = NSSelectorFromString(modeMethod2);
            NSMethodSignature * sig = [klass methodSignatureForSelector:modeSelector];
            NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:sig];
            [invocation setTarget:klass];
            [invocation setSelector:modeSelector];
            if (sig.numberOfArguments == 3)
            {
                [invocation setArgument:&params atIndex:2];
            }
            else if (sig.numberOfArguments == 4)
            {
                [invocation setArgument:&params atIndex:2];
                [invocation setArgument:&finish atIndex:3];
            }
            [invocation invoke];
        }
        else
        {
            //模式3
            NSString *modeMethod3 = nil;
            for (NSString *methodName in classMethods)
            {
                if ([methodName hasPrefix:methodMode3Prefix])
                {
                    modeMethod3 = methodName;
                    break;
                }
            }
            if (modeMethod3)
            {
                NSString *paramString = nil;
                NSString *urlString = url.absoluteString;
                NSUInteger firstQuestionMark = [urlString rangeOfString:@"?"].location;
                if (firstQuestionMark != NSNotFound)
                {
                    paramString = [urlString substringFromIndex:firstQuestionMark + 1];
                }
                SEL modeSelector = NSSelectorFromString(modeMethod3);
                NSMethodSignature * sig = [klass methodSignatureForSelector:modeSelector];
                NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:sig];
                [invocation setTarget:klass];
                [invocation setSelector:modeSelector];
                if (sig.numberOfArguments == 3)
                {
                    [invocation setArgument:&paramString atIndex:2];
                }
                else if (sig.numberOfArguments == 4)
                {
                    [invocation setArgument:&paramString atIndex:2];
                    [invocation setArgument:&finish atIndex:3];
                }
                [invocation invoke];
            }
            else
            {
                //模式4
                SEL modeSelector = NSSelectorFromString(@"hgoto");
                SEL modeSelectorWithFinish = NSSelectorFromString(@"hgotoWithFinish:");
                if ([klass respondsToSelector:modeSelector])
                {
                    NSMethodSignature * sig = [klass methodSignatureForSelector:modeSelector];
                    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:sig];
                    [invocation setTarget:klass];
                    [invocation setSelector:modeSelector];
                    [invocation invoke];
                }
                else if ([klass respondsToSelector:modeSelectorWithFinish])
                {
                    NSMethodSignature * sig = [klass methodSignatureForSelector:modeSelectorWithFinish];
                    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:sig];
                    [invocation setTarget:klass];
                    [invocation setSelector:modeSelectorWithFinish];
                    [invocation setArgument:&finish atIndex:2];
                    [invocation invoke];
                }
            }
        }
    }
    [self.pasteboard removeAllObjects];
    id res = self.autoRoutedVC;
    self.autoRoutedVC = nil;
    return res;
}

+ (void)route:(NSString *)path
{
    [HGoto route:path finish:nil];
}

+ (void)route:(NSString *)path success:(callback)success faile:(fail_callback)faile
{
    [[HGoto center] route:path doJump:YES finish:^(id sender, id data, NSError *error) {
        if (error)
        {
            if (faile) faile(sender, error);
        }
        else
        {
            if (success) success(sender, data);
        }
    }];
}
+ (void)route:(NSString *)path finish:(finish_callback)finish
{
    [[HGoto center] route:path doJump:YES finish:finish];
}
+ (UIViewController *)getViewController:(NSString *)path
{
    return [[HGoto center] route:path doJump:NO finish:nil];
}
- (id)applyOptions:(NSArray *)options doJump:(BOOL)doJump targetClass:(Class)klass params:(NSDictionary *)params
{
    if ([klass isSubclassOfClass:[UIViewController class]])
    {
        UIViewController *targetVC = nil;
        BOOL needPopAction = NO;
        if (![options containsObject:HGotoOpt_ManualRoute])
        {
            //处理autopop
            if ([options containsObject:HGOtoOpt_AutoPop])
            {
                NSArray *vcs = self.config.navi.viewControllers;
                BOOL found = NO;
                for (UIViewController *vc in vcs)
                {
                    if ([vc isKindOfClass:klass])
                    {
                        found = YES;
                        targetVC = vc;
                        needPopAction = YES;
                        break;
                    }
                }
                if (!found)
                {
                    targetVC = [klass new];
                }
            }
            else
            {
                targetVC = [klass new];
            }
            
            //处理autofill
            if ([options containsObject:HGOtoOpt_AutoFill])
            {
                NSDictionary *keyMaping = [self getOptKeyMap:options];
                NSArray<HGOTOPropertyDetail *> *pplist = [HGotoRuntimeSupport entityPropertyDetailList:targetVC.class isDepSearch:YES];
                for (HGOTOPropertyDetail *ppDetail in pplist)
                {
                    NSString *mappedKey = nil;
                    if (keyMaping) mappedKey = keyMaping[ppDetail.name];
                    if (!mappedKey) mappedKey = ppDetail.name;
                    
                    id value = [params valueForKeyPath:mappedKey];
                    if (value)
                    {
                        if ([value isKindOfClass:[NSNull class]])
                        {
                            continue;
                        }
                        else if ([value isKindOfClass:[NSString class]])
                        {
                            
                            if ([ppDetail.typeString isEqualToString:NSStringFromClass([NSString class])] || [ppDetail.typeString isEqualToString:NSStringFromClass([NSMutableString class])])
                            {
                                [targetVC setValue:[value stringValue] forKey:ppDetail.name];
                            }
                            else if (!ppDetail.isObj)
                            {
                                //基本类型
                                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                                NSNumber *valueNum = [formatter numberFromString:value];
                                //if cannot convert value to number , set to 0 by defaylt
                                if (!valueNum) valueNum = @(0);
                                [targetVC setValue:valueNum forKey:ppDetail.name];
                            }
                            else if (ppDetail.isObj && [ppDetail.typeString isEqualToString:NSStringFromClass([NSNumber class])])
                            {
                                //NSNumber
                                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                                NSNumber *valueNum = [formatter numberFromString:value];
                                //if cannot convert value to number , set to 0 by defaylt
                                if (!valueNum) valueNum = @(0);
                                [targetVC setValue:valueNum forKey:ppDetail.name];
                            }
                            else if (ppDetail.isObj && [ppDetail.typeString isEqualToString:NSStringFromClass([NSDate class])])
                            {
                                //NSDate
                                double date = [value floatValue];
                                [targetVC setValue:[NSDate dateWithTimeIntervalSince1970:date] forKey:ppDetail.name];
                            }
                        }
                    }
                }
                
            }
            if (doJump)
            {
                if (needPopAction)
                {
                    [self.config.navi popToViewController:targetVC animated:YES];
                }
                else
                {
                    [self.config.navi pushViewController:targetVC animated:YES];
                }
            }
        }
        return targetVC;
    }
    else
    {
        return nil;
    }
}
- (NSDictionary *)getOptKeyMap:(NSArray *)options
{
    for (id obj in options)
    {
        if ([obj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *keyMap = [(NSDictionary *)obj objectForKey:@"HGOtoOpt_KeyMap"];
            if (keyMap)
            {
                NSMutableDictionary *revertKeyMap = [NSMutableDictionary new];
                [keyMap enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    [revertKeyMap setObject:key forKey:obj];
                }];
                return revertKeyMap;
            }
        }
    }
    return nil;
}
+ (void)pushObject:(id)object forkey:(NSString *)key
{
    [[HGoto center].pasteboard setObject:object forKey:key];
}
+ (id)getObject:(id)object forkey:(NSString *)key
{
    return [[HGoto center].pasteboard objectForKey:key];
}
+ (id)autoRoutedVC
{
    return [HGoto center].autoRoutedVC;
}
@end

#import <objc/runtime.h>
@implementation UIViewController (hgoto)

@dynamic gotoCallback;

static const void *gotoCallbackAddress = &gotoCallbackAddress;

- (finish_callback)gotoCallback
{
    return objc_getAssociatedObject(self, gotoCallbackAddress);
}

- (void)setGotoCallback:(finish_callback)gotoCallback
{
    objc_setAssociatedObject(self, gotoCallbackAddress, gotoCallback, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
