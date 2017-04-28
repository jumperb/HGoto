//
//  HGotoRuntimeSupport.m
//  HGoto
//
//  Created by zct on 2017/4/28.
//  Copyright © 2017年 zhangchutian. All rights reserved.
//

#import "HGotoRuntimeSupport.h"
#import <objc/runtime.h>

@implementation HGOTOPropertyDetail

@end

@implementation HGotoRuntimeSupport
+ (NSArray *)_entityPropertylist:(Class)entityClass isDepSearch:(BOOL)deepSearch;
{
    NSMutableArray *pplist = [[NSMutableArray alloc] init];
    if (!entityClass) return nil;
    while (entityClass != [NSObject class]) {
        unsigned int count, i;
        objc_property_t *properties = class_copyPropertyList(entityClass, &count);
        if (count)
        {
            for (i = 0; i < count; i++)
            {
                objc_property_t property = properties[i];
                NSString *key = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
                if ([key isEqualToString:@"hash"]) continue;
                else if ([key isEqualToString:@"superclass"]) continue;
                else if ([key isEqualToString:@"description"]) continue;
                else if ([key isEqualToString:@"debugDescription"]) continue;
                else if ([key hasPrefix:@"tmp_"]) continue;
                else if ([key isEqualToString:@"format_error"]) continue;
                [pplist addObject:key];
            }
        }
        free(properties);
        if (!deepSearch) break;
        entityClass = class_getSuperclass(entityClass);
    }

    return pplist;
}

+ (NSArray<HGOTOPropertyDetail *> *)entityPropertyDetailList:(Class)entityClass isDepSearch:(BOOL)deepSearch
{

    NSMutableArray *detailList = [NSMutableArray new];
    if (!entityClass) return nil;
    NSArray *pplist = [self _entityPropertylist:entityClass isDepSearch:deepSearch];
    for (NSString *p in pplist)
    {
        //get properties
        objc_property_t pp_t = class_getProperty(entityClass, [p cStringUsingEncoding:NSUTF8StringEncoding]);
        if (!pp_t)
        {
            NSAssert(NO, @"can not get property attr : %@",p);
            return nil;
        }
        const char* attr = property_getAttributes(pp_t);
        //T@"Test",&,N,V_c"
        //Ti,N,V_a
        //T@"NSNumber<HEOptional>",&,N,V_z
        //T@,&,N
        unsigned long len = strlen(attr);
        
        if (len < 2)
        {
            NSAssert(NO, @"property attr format error : %@",p);
            return nil;
        }
        
        BOOL isObj = (attr[1] == '@');
        NSString *typeString = nil;
        NSString *protocalString = nil;
        BOOL hasProtocal = NO;
        char *leftJian = NULL;
        char *rightJian = NULL;
        
        
        
        if (isObj)
        {
            char *firstDouhao = strstr(attr, ",");
            if (firstDouhao == NULL)
            {
                NSAssert(NO, @"property attr format error : %@",p);
                return nil;
            }
            
            leftJian = strstr(attr, "<");
            rightJian = NULL;
            if (leftJian != NULL)
            {
                
                rightJian = strstr(attr, ">");
                if (rightJian == NULL)
                {
                    NSAssert(NO, @"property attr format error : %@",p);
                    return nil;
                }
                hasProtocal = YES;
            }
            
            NSString *attrString = [NSString stringWithCString:attr encoding:NSUTF8StringEncoding];
            NSString *rudeTypeString = nil;
            if (firstDouhao - attr > 4)
            {
                rudeTypeString = [attrString substringWithRange:NSMakeRange(3, firstDouhao - attr - 3 - 1)];
            }
            else
            {
                rudeTypeString = @"";
            }
            if (!hasProtocal) typeString = rudeTypeString;
            else
            {
                typeString = [attrString substringWithRange:NSMakeRange(3, leftJian - attr - 3)];
                protocalString = [attrString substringWithRange:NSMakeRange(leftJian - attr + 1, rightJian - leftJian - 1)];
            }
        }
        HGOTOPropertyDetail *detail = [HGOTOPropertyDetail new];
        detail.name = p;
        detail.isObj = isObj;
        detail.typeCode = attr[1];
        detail.typeString = typeString;
        detail.protocalString = protocalString;
        [detailList addObject:detail];
        
    }
    return detailList;
}
@end
