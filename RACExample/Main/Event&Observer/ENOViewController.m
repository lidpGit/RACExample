//
//  ENOViewController.m
//  RACExample
//
//  Created by lidp on 2016/12/26.
//  Copyright © 2016年 lidp. All rights reserved.
//

#import "ENOViewController.h"
#import <ReactiveCocoa/RACReturnSignal.h>

@interface ENOViewController ()

@property (strong, nonatomic) NSString *name;

@end

@implementation ENOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.setBackgroundColor([UIColor whiteColor]);
    self.navigationItem.rightBarButtonItem = DPTitleBarButtonItem(@"改变属性").addAction(self, @selector(changeProperty));
    
    //KVO，写法1
//    [[self rac_valuesForKeyPath:@"name" observer:nil] subscribeNext:^(id x) {
//        NSLog(@"%@", x);
//    }];
    
    //KVO，写法2
    [RACObserve(self, name) subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];

    //通知
    UITextField *tf = DPTextField().setBorderStyle(UITextBorderStyleRoundedRect);
    self.view.addSubview(tf);
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(@80);
        make.height.equalTo(@33);
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        //x为NSNotification对象
        NSLog(@"键盘将要出现, x = %@", x);
    }];
    
    //监听文本框值改变
//    [tf.rac_textSignal subscribeNext:^(id x) {
//        //x为当前文本框的text
//        NSLog(@"%@", x);
//    }];
    
    [[tf.rac_textSignal bind:^RACStreamBindBlock{
        return ^RACStream *(id value, BOOL *stop){
            return [RACReturnSignal return:[NSString stringWithFormat:@"log:%@", value]];
        };
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    //监听事件
    UIButton *btn = DPButton().setTitle(@"click", UIControlStateNormal).
    setTitleColor([UIColor whiteColor], UIControlStateNormal).
    setBackgroundColor([UIColor cyanColor], UIControlStateNormal);
    self.view.addSubview(btn);
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 30));
        make.top.equalTo(@120);
        make.centerX.equalTo(self.view);
    }];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        //x为按钮对象
        NSLog(@"点击按钮, x = %@", x);
    }];
}

- (void)changeProperty{
    static NSInteger num = 1;
    self.name = [NSString stringWithFormat:@"%zi", num];
    num ++;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.view.endEditing(YES);
}

@end
