//
//  HGoToWeb.m
//  Camera360
//
//  Created by zhangchutian on 14-6-20.
//  Copyright (c) 2014年 Pinguo. All rights reserved.
//

#import "HGoToWeb.h"
#import "HGoTo.h"

@implementation HGoToWeb

HGotoReg(@"web")

+ (void)hgoto_url:(NSString *)url inapp:(BOOL)inapp
{
    if (!inapp)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[url decode]]];
    }
    else
    {
        [[UIApplication sharedApplication] openURLInApp:[NSURL URLWithString:[url decode]]];
    }
}

@end
