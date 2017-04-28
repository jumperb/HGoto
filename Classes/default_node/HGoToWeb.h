//
//  HGoToWeb.h
//  Camera360
//
//  Created by zhangchutian on 14-6-20.
//  Copyright (c) 2014年 Pinguo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  打开网页跳
 */
@interface HGoToWeb : NSObject
+ (void)hgoto_url:(NSString *)url inapp:(BOOL)inapp;
@end
