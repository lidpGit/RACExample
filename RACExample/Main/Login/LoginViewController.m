//
//  LoginViewController.m
//  Test
//
//  Created by lidp on 2016/12/22.
//  Copyright © 2016年 lidp. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginViewModel.h"

@interface LoginViewController ()

@property (strong, nonatomic) UITextField *nameTF;
@property (strong, nonatomic) UITextField *passwordTF;
@property (strong, nonatomic) UIButton *loginBtn;
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) LoginViewModel *viewModel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutUI];
    [self bindViewModel];
}

- (void)layoutUI{
    self.view.setBackgroundColor(RGB(240, 240, 240));
    
    //用户名
    _nameTF = DPTextField().setPlaceholder(@"输入用户名");
    _nameTF.setBorderStyle(UITextBorderStyleRoundedRect).
        setFont([UIFont systemFontOfSize:15]).
        setClearButtonMode(UITextFieldViewModeWhileEditing);
    self.view.addSubview(_nameTF);
    [_nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@80);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@40);
    }];
    
    //密码
    _passwordTF = DPTextField().setPlaceholder(@"输入密码");
    _passwordTF.setBorderStyle(UITextBorderStyleRoundedRect).
        setFont([UIFont systemFontOfSize:15]).
        setClearButtonMode(UITextFieldViewModeWhileEditing).
        setKeyboardType(UIKeyboardTypeNumberPad);
    self.view.addSubview(_passwordTF);
    [_passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(_nameTF);
        make.top.equalTo(_nameTF.mas_bottom).offset(15);
    }];
    
    //登录按钮
    _loginBtn = DPButton();
    _loginBtn.setTitle(@"登录", UIControlStateNormal).
        setTitleColor([UIColor whiteColor], UIControlStateNormal).
        setTitleFont([UIFont systemFontOfSize:15]).
        setBackgroundColor([UIColor redColor].setAlpha(0.5), UIControlStateHighlighted).
        setCornerRadius(5);
    self.view.addSubview(_loginBtn);
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_nameTF);
        make.top.equalTo(_passwordTF.mas_bottom).offset(15);
        make.height.equalTo(@45);
    }];
    
    //登录状态
    _statusLabel = DPLabel().setBackgroundColor([UIColor clearColor]);
    _statusLabel.setFont([UIFont systemFontOfSize:15]).
        setTextColor([UIColor redColor]).
        setTextAlignment(NSTextAlignmentCenter);
    self.view.addSubview(_statusLabel);
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_nameTF);
        make.height.equalTo(@16);
        make.top.equalTo(_loginBtn.mas_bottom).offset(15);
    }];
}

- (void)bindViewModel{
    self.viewModel = [[LoginViewModel alloc] init];
    //绑定viewModel的name属性，用户名输入框值改变时，name属性跟着改变
    RAC(self.viewModel, name) = self.nameTF.rac_textSignal;
    RAC(self.viewModel, password) = self.passwordTF.rac_textSignal;
    
    //绑定状态label的text属性，viewModel的status属性改变时，text跟着改变
    RAC(self.statusLabel, text) = RACObserve(self.viewModel, status);
    
    //绑定按钮状态
    self.loginBtn.rac_command = self.viewModel.loginCommand;
    @weakify(self);
    [self.viewModel.validInfoSignal subscribeNext:^(id x) {
        @strongify(self);
        BOOL enabled = [x boolValue];
        self.loginBtn.setBackgroundColor(enabled ? [UIColor redColor] : RGB(190, 190, 190), UIControlStateNormal);
    }];
    
    [self.loginBtn.rac_command.executing subscribeNext:^(id x) {
        @strongify(self);
        NSLog(@"是否在执行：%@", x);
        if ([x boolValue]) {
            self.view.endEditing(YES);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.view.endEditing(YES);
}

@end
