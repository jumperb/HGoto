# HGoto
这是一个app内路由小工具，你可以用他来处理来自推送，urlschema，universal url，深链，网页调用，app的消息中心的消息或者调用，还可以用于服务器下发跳转逻辑，例如banner
# 使用方法

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
