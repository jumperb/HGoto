//
//  CViewController.m
//  HGoto
//
//  Created by zhangchutian on 14/12/3.
//  Copyright (c) 2014年 zhangchutian. All rights reserved.
//

#import "CViewController.h"
#import "HGoto.h"
#import <HCommon.h>

@implementation CViewController1
HGotoReg2(@"c1",HGotoOpt_ManualRoute)
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"C1";
}
+ (id)hgoto_pa:(NSString *)pa
{
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    transition.duration = 0.3;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [[UIApplication navi].view.layer addAnimation:transition forKey:kCATransition];
    UIViewController *vc = [CViewController1 new];
    [[UIApplication navi] pushViewController:vc animated:NO];
    return vc;
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
    textView.text = [NSString stringWithFormat:@"pa=%@,PB=%d,pc=%@", self.pa,self.PB,self.pc];
}
@end

@implementation CViewController4

HGotoReg2(@"c4", HGOtoOpt_AutoFill, HGOtoOpt_KeyMap((@{@"pa":@"eee",@"pb":@"FFF",@"pc":@"ggg"})))

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"C4";
    UITextView *textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.view = textView;
    textView.text = [NSString stringWithFormat:@"eee=%@,FFF=%d,ggg=%@", self.eee,self.FFF,self.ggg];
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
