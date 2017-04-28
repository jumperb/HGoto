//
//  CViewController.m
//  HGoto
//
//  Created by zhangchutian on 14/12/3.
//  Copyright (c) 2014年 zhangchutian. All rights reserved.
//

#import "CViewController.h"
#import "HGoTo.h"

@implementation CViewController1

HGotoReg2(@"c1",HGotoOpt_ManualRoute)

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"C1";
}
+ (void)hgoto_pa:(NSString *)pa
{
    [[UIApplication navi] pushViewController:[CViewController1 new] animated:YES];
}
@end


@implementation CViewController2

HGotoReg2(@"c2",HGOtoOpt_AutoPop)

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"C2";
    UITextView *textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.view = textView;
    textView.text = self.pa;
}
- (void)setPa:(NSString *)pa
{
    _pa = pa;
    [(UITextView *)self.view setText:pa];
}
+ (void)hgoto_pa:(NSString *)pa
{
    CViewController2 *vc = [HGoto autoRoutedVC];
    vc.pa = pa;
}
@end


@implementation CViewController3

HGotoReg2(@"c3",HGOtoOpt_AutoFill)

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"C3";
    UITextView *textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.view = textView;
    textView.text = [NSString stringWithFormat:@"pa=%@,pb=%d,pc=%@", self.pa,self.pb,self.pc];
}
@end

@implementation CViewController4

HGotoReg2(@"c4", HGOtoOpt_AutoFill, HGOtoOpt_KeyMap((@{@"pa":@"eee",@"pb":@"fff",@"pc":@"ggg"})))

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"C4";
    UITextView *textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.view = textView;
    textView.text = [NSString stringWithFormat:@"eee=%@,fff=%d,ggg=%@", self.eee,self.fff,self.ggg];
}
@end


@implementation CViewController5

HGotoReg(@"c5")

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"C5";
}
+ (void)hgotoWithParams:(NSDictionary *)paramMap finish:(finish_callback)finish
{
    NSLog(@"hgotoWithParams:finish: CViewController5");
}

@end

@implementation CViewController6

HGotoReg(@"c6")

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"C6";
}
+ (void)hgoto
{
    NSLog(@"hgoto CViewController6");
}
@end
