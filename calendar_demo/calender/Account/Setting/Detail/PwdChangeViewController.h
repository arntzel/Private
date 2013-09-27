//
//  PwdChangeViewController.h
//  Calvin
//
//  Created by tu changwei on 13-9-27.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "SettingsBaseViewController.h"

@interface PwdChangeViewController : SettingsBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *oldPwdField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UITextField *rePwdField;

@end
