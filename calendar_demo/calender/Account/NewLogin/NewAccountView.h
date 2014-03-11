//
//  NewAccountView.h
//  Calvin
//
//  Created by Kevin Wu on 3/9/14.
//  Copyright (c) 2014 Pencil Me, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateUser.h"
@protocol NewAccountViewDelegate <NSObject>

@optional
- (void)doCreateAccountWithName:(CreateUser *) createUser;

@end
@interface NewAccountView : UIView <UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *profileView;
@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutlet UITextField *lastName;
@property (strong, nonatomic) IBOutlet UITextField *firstName;
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UITextField *zipCode;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) UIViewController<NewAccountViewDelegate> *delegate;

+(NewAccountView *) createWithDelegate:(UIViewController<NewAccountViewDelegate> *) theDelegate;
@end


