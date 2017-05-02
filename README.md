# HGoto
这是一个app内路由小工具，你可以用他来处理来自推送，urlschema，universal url，深链，网页调用，app的消息中心的消息或者调用，还可以用于服务器下发跳转逻辑，例如banner。相比其他同类库，它具有如下特点
* 支持自由，所见即所得的路由处理函数  
* 支持自动跳转和手动跳转  
* 支持参数自动填充  
* 支持参数keymap  
* 支持“二段跳”，即next关键字  
* 支持跳转后返回并携带数据  
* 支持数据暂存，类似剪贴板  

# 使用方法
例如:你想添加一个对BViewController的跳转，并携带参数，那么设计好的链接如下  
HGoto://b?pa=1&pb=2&pc=3

1.在podfile中添加 pod 'HGoto'并更新  
2.为一个类添加路由节点  
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

3.在浏览器地址栏填入HGoto://b?pa=1&pb=2&pc=3试试吧，注意改成你的schema  
4.其他例子见demo
