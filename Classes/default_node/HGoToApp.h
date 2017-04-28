//
//  HGoToApp.h
//  Camera360
//
//  Created by zhangchutian on 14-6-20.
//  Copyright (c) 2014年 Pinguo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
/**
 *  第三方应用跳转点
 *  1.直接打开应用 需要schema参数，优先级高
 *  2.打开某个url地址，优先级低
 *
 *
 *  支持参数 url=xxx&schema=xxx
 */
@interface HGoToApp : NSObject
+ (void)hgoto_schema:(NSString *)schema url:(NSString *)url;
@end
