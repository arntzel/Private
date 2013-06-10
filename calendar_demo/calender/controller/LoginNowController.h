//
//  LoginNowController.h
//  calender
//
//  Created by xiangfang on 13-6-10.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginNowController : UIViewController

@property IBOutlet UITextField * tvUsername;
@property IBOutlet UITextField * tvPassword;
@property IBOutlet UIButton * btnLogin;

@property IBOutlet UIBarButtonItem * btnBack;

@property IBOutlet UIActivityIndicatorView * progress;


-(IBAction) back:(id)sender;

-(IBAction) login:(id)sender;

@end
