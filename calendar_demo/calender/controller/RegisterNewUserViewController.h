//
//  RegisterNewUserViewController.h
//  calender
//
//  Created by xiangfang on 13-6-30.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterNewUserViewController : UIViewController

@property IBOutlet UITextField * tfUsername;
@property IBOutlet UITextField * tfEmail;
@property IBOutlet UITextField * tfPassword;
@property IBOutlet UIActivityIndicatorView * indicator;

@property IBOutlet UIButton * btnSignup;


-(IBAction) cancel:(id)sender;

-(IBAction) signup:(id)sender;

@end
