//
//  EmailChangeViewController.h
//  Calvin
//
//  Created by tu changwei on 13-9-26.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "SettingsBaseViewController.h"

@interface EmailChangeViewController : SettingsBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *confirmEmailField;

@end
