//
//  OnboardingViewController.h
//  Calvin
//
//  Created by Kevin Wu on 3/8/14.
//  Copyright (c) 2014 Pencil Me, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@protocol OnBoardingViewControllerDelegate <NSObject>

@optional
-(void)showOtherOption;
-(void)signUpGoogle;

@end

@interface OnboardingViewController : UIViewController <OnBoardingViewControllerDelegate>

-(void)setDelegate:(id<LoginViewControllerDelegate>) theDelegate;

@end
