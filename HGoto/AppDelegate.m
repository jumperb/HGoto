//
//  AppDelegate.m
//  HGoto
//
//  Created by zhangchutian on 14/12/3.
//  Copyright (c) 2014年 zhangchutian. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuVC.h"
#import <HCommon.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    MenuVC *vc = [MenuVC new];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    [navi.navigationBar setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithWhite:1 alpha:0.5]] forBarMetrics:UIBarMetricsDefault];
//    [navi.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
