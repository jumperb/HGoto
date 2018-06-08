//
//  ViewController.m
//  HGoto
//
//  Created by zhangchutian on 14/12/3.
//  Copyright (c) 2014年 zhangchutian. All rights reserved.
//

#import "MenuVC.h"
#import "HGoTo.h"
#import "CViewController.h"
#import "BViewController.h"
#import <HCommon.h>

@interface MenuVC ()

@end

@implementation MenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"MENU";
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImage.contentMode = UIViewContentModeScaleAspectFill;
    ALWAYS_FULL(bgImage);
    bgImage.image = [UIImage imageNamed:@"bg.jpg"];
    [self.view addSubview:bgImage];
    UIView *bg = [[UIView alloc] initWithFrame:self.view.bounds];
    ALWAYS_FULL(bg);
    bg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:bg];

    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    ALWAYS_FULL(_tableView);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDatasource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 14;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: return 120;
            break;

        default: return 60;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.shadowColor = [UIColor blackColor];
        cell.textLabel.shadowOffset = CGSizeMake(0, -1);
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = [UIView new];
        cell.backgroundView.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.shadowColor = [UIColor blackColor];
        cell.detailTextLabel.shadowOffset = CGSizeMake(0, -1);
    }
    cell.textLabel.text = @"";
    cell.detailTextLabel.text = @"";
    cell.imageView.image = nil;
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"简介";
            cell.detailTextLabel.text = @"可以用于解决产品想要的“到处乱跳的问题”，并且不会因此带来过多的耦合度,\n\
            使用方式很简单.你可以在消息中心，url调用，web反调，universal url，推送消息，运营支持等场景使用他，使用方式见demo";
            break;
        case 1:
            cell.textLabel.text = @"简单跳转";
            cell.detailTextLabel.text = @"跳到AController 路径为HGoto://a";
            break;
        case 2:
            cell.textLabel.text = @"携带参数";
            cell.detailTextLabel.text = @"跳到BController携带参数pa=1,PB=2,pc=ccccccc";
            break;
        case 3:
            cell.textLabel.text = @"选项: HGotoOpt_ManualRoute";
            cell.detailTextLabel.text = @"手动做跳转动画";
            break;
        case 4:
            cell.textLabel.text = @"选项: HGOtoOpt_AutoPop";
            cell.detailTextLabel.text = @"如果栈里面有同类vc，则自动pop并填值";
            break;
        case 5:
            cell.textLabel.text = @"选项: HGOtoOpt_AutoFill";
            cell.detailTextLabel.text = @"自动填充值，不用去写值填充代码了，仅对vc有效";
            break;
        case 6:
            cell.textLabel.text = @"选项: HGOtoOpt_KeyMap";
            cell.detailTextLabel.text = @"自动填充时可以用keymap做参数名转换";
            break;
        case 7:
            cell.textLabel.text = @"模式匹配 hgotoWithParams";
            cell.detailTextLabel.text = nil;
            break;
        case 8:
            cell.textLabel.text = @"其他模式匹配 hgoto";
            cell.detailTextLabel.text = nil;
            break;
        case 9:
            cell.textLabel.text = @"next关键字";
            cell.detailTextLabel.text = nil;
            break;
        case 10:
            cell.textLabel.text = @"内置跳转点 app";
            cell.detailTextLabel.text = nil;
            break;
        case 11:
            cell.textLabel.text = @"内置跳转点 web";
            cell.detailTextLabel.text = nil;
            break;
        case 12:
            cell.textLabel.text = @"继承关系";
            cell.detailTextLabel.text = nil;
            break;
        case 13:
            cell.textLabel.text = @"仅仅获取VC不跳转";
            cell.detailTextLabel.text = nil;
        default:
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 1:
            [HGoto route:@"HGoto://a"];
            break;
        case 2:
            //这一条注意下BViewController这个方法的方法体
            [HGoto route:@"HGoto://b?pa=1&PB=2&pc=3" finish:^(id sender, UIImage *data, NSError *error) {
                if (error)
                {
                    NSLog(@"%@", error);
                }
                else
                {
                    NSLog(@"%@", data);
                }
            }];
            break;
        case 3:
            [HGoto route:@"HGoto://c1?pa=1&pb=2&pc=3"];
            break;
        case 4:
            //栈里面已经存在CViewController2
            [HGoto route:@"HGoto://c2?pa=oldoldoldoldoldoldoldoldoldoldoldold&pb=2&pc=3"];
            [HGoto route:@"HGoto://b"];
            dispatchAfter(2, ^{
                [HGoto route:@"HGoto://c2?pa=newnewnewnewnewnewnewnewnewnewnewnew&pb=2&pc=3"];
            });
            
            break;
        case 5:
            [HGoto route:@"HGoto://c3?pa=1&PB=2&pc=3"];
            break;
        case 6:
            [HGoto route:@"HGoto://c4?pa=1&pb=2&pc=3"];
            break;
        case 7:
            [HGoto route:@"HGoto://c5?pa=1&pb=2&pc=3"];
            break;
        case 8:
            [HGoto route:@"HGoto://c6?pa=1&pb=2&pc=3"];
            break;
        case 9:
            [HGoto route:@"HGoto://b?pa=1&PB=2&pc=3&next=HGoto%3a%2f%2fa"];
            break;
        case 10:
            [HGoto route:@"HGoto://app?schema=wechat%3a%2f%2f&url=https%3a%2f%2fitunes.apple.com%2fus%2fapp%2fwechat%2fid414478124%3fmt%3d8"];
            break;
        case 11:
            [HGoto route:@"HGoto://web?url=https%3a//www.baidu.com?a=1&b=2"];
            break;
        case 12:
            [HGoto route:@"HGoto://a2"];
            break;
        case 13:{
            id res = [HGoto getViewController:@"HGoto://c4?pa=1&pb=2&pc=3"];
            NSLog(@"res = %@", res);
            break;
        }
        default:
            break;
    }
}
@end
