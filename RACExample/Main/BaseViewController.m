//
//  BaseViewController.m
//  RACExample
//
//  Created by lidp on 2016/12/26.
//  Copyright © 2016年 lidp. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)dealloc{
    NSLog(@"[%@ dealloc]", self.class);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.setBackgroundColor([UIColor whiteColor]);
}

- (UIButton *)operateBtn{
    if (!_operateBtn) {
        _operateBtn = DPButton().setBackgroundColor([UIColor orangeColor], UIControlStateNormal).setBackgroundColor([UIColor orangeColor].setAlpha(0.5), UIControlStateHighlighted);
        _operateBtn.setTitleColor([UIColor whiteColor], UIControlStateNormal).setTitle(@"点我测试", UIControlStateNormal);
        self.view.addSubview(_operateBtn);
        [_operateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(120, 44));
            make.center.equalTo(self.view);
        }];
    }
    return _operateBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
