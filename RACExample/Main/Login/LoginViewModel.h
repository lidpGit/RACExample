//
//  LoginViewModel.h
//  Test
//
//  Created by lidp on 2016/12/22.
//  Copyright © 2016年 lidp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginViewModel : NSObject

@property (copy, nonatomic  ) NSString *name;
@property (copy, nonatomic  ) NSString *password;
@property (copy, nonatomic  ) NSString *status;
@property (strong, nonatomic) RACCommand *loginCommand;
@property (strong, nonatomic) RACSignal *validInfoSignal;

@end
