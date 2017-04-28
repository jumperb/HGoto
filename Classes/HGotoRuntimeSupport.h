//
//  HGotoRuntimeSupport.h
//  HGoto
//
//  Created by zct on 2017/4/28.
//  Copyright © 2017年 zhangchutian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGOTOPropertyDetail : NSObject
@property (nonatomic) NSString *name;
@property (nonatomic) BOOL isObj;
@property (nonatomic) char typeCode;
@property (nonatomic) NSString *typeString;
@property (nonatomic) NSString *protocalString;
@end

@interface HGotoRuntimeSupport : NSObject
+ (NSArray<HGOTOPropertyDetail *> *)entityPropertyDetailList:(Class)entityClass isDepSearch:(BOOL)deepSearch;
@end
