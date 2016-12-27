//
//  ReplaceDelegateViewController.m
//  Test
//
//  Created by lidp on 2016/12/23.
//  Copyright © 2016年 lidp. All rights reserved.
//

#import "ReplaceDelegateViewController.h"

@interface ReplaceDelegateViewController ()<UITextFieldDelegate>

@end

@implementation ReplaceDelegateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.setBackgroundColor([UIColor whiteColor]);
    
    UITextField *tf1 = DPTextField().setBorderStyle(UITextBorderStyleRoundedRect).setDelegate(self);
    self.view.addSubview(tf1);
    [tf1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@80);
        make.height.equalTo(@33);
        make.right.equalTo(self.view).offset(-15);
    }];
    
    UITextField *tf2 = DPTextField().setBorderStyle(UITextBorderStyleRoundedRect).setDelegate(self);
    self.view.addSubview(tf2);
    [tf2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(tf1);
        make.top.equalTo(tf1.mas_bottom).offset(15);
    }];
    
    //键盘点击return按钮，返回的是RACTuple对象
    [[self rac_signalForSelector:@selector(textFieldShouldReturn:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(RACTuple *tuple) {
        [tuple.first resignFirstResponder];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.view.endEditing(YES);
}

@end
