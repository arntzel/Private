//
//  LoginViewController.h
//  Calvin
//
//  Created by Kevin Wu on 3/4/14.
//  Copyright (c) 2014 Pencil Me, Inc. All rights reserved.
//

#import "BaseUIViewController.h"

@interface LoginViewController : BaseUIViewController

-(id)init;

@end

@protocol LoginViewControllerDelegate <NSObject>

@optional

-(void)doLoginFacebook;
-(void)doLoginGoogle;
-(void)doLoginWithEmail:(NSString *)email password:(NSString *)password;
-(void)doSignupFacebook;
-(void)doSignupGoogle;
-(void)doSignupWithUser;
-(void)doFogotPassword;

@end