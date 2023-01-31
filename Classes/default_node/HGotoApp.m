//
//  HGotoApp.m
//  Camera360
//
//  Created by zhangchutian on 14-6-20.
//  Copyright (c) 2014年 Pinguo. All rights reserved.
//

#import "HGotoApp.h"
#import "HGoto.h"
#import <Hodor/NSString+ext.h>

@interface HGotoApp () <SKStoreProductViewControllerDelegate>

@property (nonatomic) id mHolder;
@property (nonatomic, weak) SKStoreProductViewController *mSkStoreProductViewController;
@end

@implementation HGotoApp

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
