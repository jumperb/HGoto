# What
这是一个非常小的app内路由工具，你可以用他来处理来自推送，urlschema，universal url，深链，网页调用，app的消息中心的消息或者调用，还可以用于服务器下发跳转逻辑，例如banner。相比其他同类库，它具有如下特点
* 支持自由，所见即所得的路由处理函数  
* 支持自动跳转和手动跳转  
* 支持参数自动填充  
* 支持参数keymap  
* 支持“二段跳”，即next关键字  
* 支持跳转后返回并携带数据  
* 支持数据暂存，类似剪贴板  

# 使用方法

## 安装
在podfile中添加 pod 'HGoto'并更新  
## 配置
实现HGotoConfig协议
```
#import "HGoTo.h"
@interface HGotoConfigIMP : NSObject <HGotoConfig>
@end
```
```
#import "HGotoConfigIMP.h"
#import <HCommon.h>

@implementation HGotoConfigIMP
HRegForProtocal(HGotoConfig)

- (NSString *)appSchema
{
    return @"HGoto://";
}
- (UINavigationController *)navi
{
    return [UIApplication navi];
}
@end
```
注意其中HRegForProtocal(HGotoConfig) 是一个注册方式，告诉上下文，取这个协议的对象来找他

## 基本使用
你想添加一个对BViewController的跳转，并携带参数，那么设计好的链接如下  
你的schema://b?pa=1&pb=2&pc=3
你需要
1.在VC的imp里面注册路径HGotoReg(@"b")
2.如果需要处理参数的话，需要编写参数处理函数hgoto_xxxxx
```
@implementation BViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"B";
    self.view.backgroundColor = [UIColor blueColor];
    UITextView *textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.view = textView;
    textView.text = [NSString stringWithFormat:@"pa=%@,pb=%d,pc=%@", self.pa,self.pb,self.pc];
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
```
注意：[HGoto autoRoutedVC] 是已经帮你创建好的VC
3.在浏览器地址栏填入"你的schema://b?pa=1&pb=2&pc=3"试试吧，注意要确认你的schema在info.plist的url-types里面

## 参数处理函数模板
需要处理参数时任选一个模式即可，其中模式1的函数方法名，由路由的入参决定，当然，少几个参数是没问题的

模式1 + (void)hgoto_p1:(NSString *)p1 p2:(NSString *)p2 p3:(NSString *)p3 finish:(finish_callback)finish
模式1 + (void)hgoto_P1:(NSString *)p1 p2:(NSString *)p2 p3:(NSString *)p3
模式2 + (void)hgotoWithParams:(NSDictionary *)paramMap finish:(finish_callback)finish
模式2 + (void)hgotoWithParams:(NSDictionary *)paramMap
模式3 + (void)hgoto:(NSString *)params finish:(finish_callback)finish
模式3 + (void)hgoto:(NSString *)params
模式4 + (void)hgotoWithFinish:(finish_callback)finish
模式4 + (void)hgoto

有的带回调，有的没带回调，按需使用就可以了


## 手动处理跳转请求
如果需要完全自己创建对象，设置参数，跳转，直接使用HGotoOpt_ManualRoute这个注解即可
```
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
```
注意，添加了这个参数，那么跳转目的地就可以不只是VC了，可以是任意NSObject子类，如果你要用这个做成一个命令或者方法调用，也是可以的

## 自动填充参数
类似于这种赋值没有多大意义
```
    BViewController *vc = [HGoto autoRoutedVC];
    vc.pa = pa;
    vc.pb = [pb intValue];
    vc.pc = @([pc intValue]);
    vc.gotoCallback = finish;
```
如果想省略掉的话，可以使用HGOtoOpt_AutoFill这个注解
```
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
```
这样，参数处理函数都省掉了

## 参数映射
在HGOtoOpt_AutoFill模式中，如果入参和你定义的属性名字不太一样，那么你需要做一下参数映射，使用HGOtoOpt_KeyMap这个注解即可
```
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
```
## 唯一VC处理
有一个页面叫CViewController2，这个页面比较重，页面栈里面只允许出现一个，如果在有跳转的情况需要退栈，对应这种需求，使用HGOtoOpt_AutoPop这个注解即可
```
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
```
可以使用如下代码测试
```
[HGoto route:@"HGoto://c2?pa=oldoldoldoldoldoldoldoldoldoldoldold&pb=2&pc=3"];
[HGoto route:@"HGoto://b"];
dispatchAfter(2, ^{
    [HGoto route:@"HGoto://c2?pa=newnewnewnewnewnewnewnewnewnewnewnew&pb=2&pc=3"];
});
```
## 直接获取VC
默认我们的跳转方式都是push，如果需要不同的跳转方式，需要自己手动跳转，
但是对于同一个VC，有时候需要push，有时候需要pop，这种情况下，可以使用这个方法
```
+ (UIViewController *)getViewController:(NSString *)path;
```
直接获取到VC对象，并且在不同地方采用不同的跳转方式
