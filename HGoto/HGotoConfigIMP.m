//
//  HGotoConfigIMP.m
//  HGoto
//
//  Created by zct on 2017/4/27.
//  Copyright © 2017年 zhangchutian. All rights reserved.
//

#import "HGotoConfigIMP.h"
#import <HCommon.h>

@implementation HGotoConfigIMP
HRegForProtocal(HGotoConfig)

- (NSArray *)appSchemas
{
    return @[@"HGoto://"];
}
- (UINavigationController *)navi
{
    return [UIApplication navi];
}
@end
