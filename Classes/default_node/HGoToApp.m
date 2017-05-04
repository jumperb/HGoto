//
//  HGoToApp.m
//  Camera360
//
//  Created by zhangchutian on 14-6-20.
//  Copyright (c) 2014年 Pinguo. All rights reserved.
//

#import "HGoToApp.h"
#import "HGoTo.h"
#import <NSString+ext.h>

@interface HGoToApp () <SKStoreProductViewControllerDelegate>

@property (nonatomic) id mHolder;
@property (nonatomic, weak) SKStoreProductViewController *mSkStoreProductViewController;
@end

@implementation HGoToApp

HGotoReg(@"app")

+ (void)hgoto_schema:(NSString *)schema url:(NSString *)url
{
    if (schema)
    {
        NSURL *schemaURL = [NSURL URLWithString:schema];
        if ([[UIApplication sharedApplication] canOpenURL:schemaURL])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:schema]];
        }
        else if (url)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[url decode]]];
        }
    }
    else
    {
        if (url)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[url decode]]];
        }
    }
}

@end
