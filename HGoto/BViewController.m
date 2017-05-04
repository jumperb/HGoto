//
//  BViewController.m
//  HGoto
//
//  Created by zhangchutian on 14/12/3.
//  Copyright (c) 2014年 zhangchutian. All rights reserved.
//

#import "BViewController.h"
#import "CViewController.h"
#import "HGoTo.h"
#import <HCommon.h>

@implementation BViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"B";
    self.view.backgroundColor = [UIColor blueColor];
    UITextView *textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.view = textView;
    textView.text = [NSString stringWithFormat:@"pa=%@,pb=%d,pc=%@", self.pa,self.pb,self.pc];
    
    dispatchAfter(2, ^{
        
        if (self.gotoCallback)
        {
            [self.navigationController popViewControllerAnimated:YES];
            UIImage *img = [UIImage imageNamed:@"bg.jpg"];
            self.gotoCallback(self, img, nil);
        }
    });
}

@end

//有一定逻辑的情况下，建议放在一个扩展里面实现路由
@implementation BViewController (hgoto)

HGotoReg(@"b")

+ (void)hgoto_pa:(NSString *)pa pb:(NSString *)pb pc:(NSString *)pc finish:(finish_callback)finish
{
    BViewController *vc = [HGoto autoRoutedVC];
    vc.pa = pa;
    vc.pb = [pb intValue];
    vc.pc = @([pc intValue]);
    vc.gotoCallback = finish;
}

@end
