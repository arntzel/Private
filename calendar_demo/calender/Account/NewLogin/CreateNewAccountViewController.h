//
//  CreateNewAccountViewController.h
//  Calvin
//
//  Created by Kevin Wu on 3/9/14.
//  Copyright (c) 2014 Pencil Me, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewAccountView.h"
#import "LoginViewController.h"

@interface CreateNewAccountViewController : UIViewController<NewAccountViewDelegate>
-(void)setDelegate:(id<LoginViewControllerDelegate>) theDelegate;
@end
