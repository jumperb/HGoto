//
//  HGotoSupport.h
//  Camera360
//
//  Created by zhangchutian on 14-4-4.
//  Copyright (c) 2014年 Pinguo. All rights reserved.
//

#ifndef HGoto_HGotoSupport_h
#define HGoto_HGotoSupport_h

#import <Hodor/HClassManager.h>
#import <Hodor/HCommonBlock.h>

#define HGOTO_NODE_REG_PREFIX @"HGOTO_NODE_REG_PREFIX"

#define HGotoReg(key) HReg(@"HGOTO_NODE_REG_PREFIX_" key) //路由节点注册
#define HGotoReg2(key, ...) HReg2(@"HGOTO_NODE_REG_PREFIX_" key, (@[__VA_ARGS__])) //路由节点注册，带选项
#define HGotoRegInfo(key,...) HRegInfo(@"HGOTO_NODE_REG_PREFIX_" key, (@[__VA_ARGS__]))  //路由信息字典

//以下是路由选项

//手动页面路由:如果节点目标是一个vc，而且需要手动写代码实现push，present等，就加上这个选项，并且自己在hgotoxxx函数里面写页面跳转代码，默认是自动push
#define HGotoOpt_ManualRoute @"HGotoOpt_ManualRoute"

//自动路由可自动POP:如果节点目标是一个vc，在自动路由的情况下，如果栈中有这个类型的vc，那么直接pop
#define HGOtoOpt_AutoPop @"HGOtoOpt_AutoPop"

//自动路由可自动填充，填充同名属性，数字和字符串可以自动转换
#define HGOtoOpt_AutoFill @"HGOtoOpt_AutoFill"

//自动路由可自动填充的前提下，可以做keymap
#define HGOtoOpt_KeyMap(keymap) @{@"HGOtoOpt_KeyMap":keymap}


#define HGotoKeyword_Next @"next"
#define HGotoPreStepDataKey @"HGotoPreStepDataKey"
#define HGotoRouteKey @"routeKey"
//模式1 + (void)hgoto_p1:(NSString *)p1 p2:(NSString *)p2 p3:(NSString *)p3 finish:(finish_callback)finish
//模式1 + (void)hgoto_P1:(NSString *)p1 p2:(NSString *)p2 p3:(NSString *)p3
//模式2 + (void)hgotoWithParams:(NSDictionary *)paramMap finish:(finish_callback)finish
//模式2 + (void)hgotoWithParams:(NSDictionary *)paramMap
//模式3 + (void)hgoto:(NSString *)params finish:(finish_callback)finish
//模式3 + (void)hgoto:(NSString *)params
//模式4 + (void)hgotoWithFinish:(finish_callback)finish
//模式4 + (void)hgoto


@protocol HGotoConfig <NSObject>
@property (nonatomic, readonly) NSString *appSchema;
@property (nonatomic, readonly) UINavigationController *navi;
@optional
- (void)openHttpURL:(NSString *)httpURL;
- (void)cannotRoute:(NSString *)path error:(NSError *)error;
@end

@interface HGoto : NSObject
@property (nonatomic, readonly) id<HGotoConfig> config;

//普通跳转
+ (void)route:(NSString *)path;
//普通跳转+回调
+ (void)route:(NSString *)path finish:(finish_callback)finish;
//普通跳转+回调
+ (void)route:(NSString *)path success:(callback)success faile:(fail_callback)faile;
//只取到VC不进行跳转，自动参数的话参数已经填好
+ (UIViewController *)getViewController:(NSString *)path;

//数据暂存，route完就删除掉
+ (void)pushObject:(id)object forkey:(NSString *)key;
+ (id)getObject:(id)object forkey:(NSString *)key;

//当前这次跳转路由目标是vc，并且自动跳转的情况下，可以通过这个来获取目标VC
+ (id)autoRoutedVC;

@end

//如果需要保存路由回调，请直接用这个
@interface UIViewController (hgoto)
@property (nonatomic) finish_callback gotoCallback;
@end

#endif
