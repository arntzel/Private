//
//  SettingsContentView.h
//  Calvin
//
//  Created by tu changwei on 13-9-25.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#define emailViewTag 1
#define pwdViewTag 2
#define fbViewTag 3
#define googleViewTag 4
#define notificationViewTag 5
#define termViewTag 6
#define policyViewTag 7
#define aboutUsViewTag 8
#define logoutBtnTag 9
#define sendFeedBackBtnTag 10
#define deleteAccountBtnTag 11
#define connectFacebookBtnTag 12
#define connectGoogleBtnTag 13
#define headPortraitBtnTag 14
#define headPortraitImgViewTag 15
#define firstNameFieldTag 16
#define lastNameFieldTag 17
@interface SettingsContentView : UIControl  
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIButton *headPortaitBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headPortraitImgView;

@property (weak, nonatomic) IBOutlet UIButton *fbConnectBtn;
@property (weak, nonatomic) IBOutlet UIButton *googleConnectBtn;
@property (weak, nonatomic) IBOutlet UILabel *fbLabel;
@property (weak, nonatomic) IBOutlet UILabel *googleLabel;
@property (weak, nonatomic) IBOutlet UIControl *fbView;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *fbTapGesture;
@property (weak, nonatomic) IBOutlet UIControl *googleView;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *googleTapGesture;


@property (nonatomic, copy) void (^pushDetailViewBlock)(int row);

- (IBAction)viewClicked:(id)sender;

@end
