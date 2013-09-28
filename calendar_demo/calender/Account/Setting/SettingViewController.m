//
//  SettingViewController.m
//  calender
//
//  Created by xiangfang on 13-8-4.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "SettingViewController.h"
#import "UserModel.h"
#import "LoginMainViewController.h"
#import "RootNavContrller.h"
#import "UserSetting.h"
#import "CoreDataModel.h"
#import "UIView+LoadFromNib.h"
#import "SettingsContentView.h"

#import "EmailChangeViewController.h"
#import "RootNavContrller.h"
#import <MessageUI/MessageUI.h>
#import "PwdChangeViewController.h"
#import "ConnectAccountViewController.h"
#import "NotificaitonViewController.h"
#import "LegalViewController.h"
#import "ViewUtils.h"
#import "UIImage+CirCle.h"
#import "Model.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <QuartzCore/QuartzCore.h>
@interface SettingViewController ()<MFMailComposeViewControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UploadImageDelegate>

@property (nonatomic, strong) UIScrollView *scroller;
@property (nonatomic, strong) SettingsContentView *t_settingsContentView;
@property (nonatomic, strong) User *loginUser;
@property (nonatomic, strong) ASIFormDataRequest * request;
@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    [self getUserInfo];
    [self setValueForViews];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Layout Helper
- (void)setupViews
{
    
    self.navigation.rightBtn.hidden = YES;
    self.navigation.titleLable.text = @"Accounts & Settings";
    
    [self.navigation.leftBtn addTarget:self action:@selector(btnMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    
    float scrollerY = CGRectGetMaxY(self.navigation.frame);
    self.scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scrollerY, self.view.frame.size.width, self.view.frame.size.height - scrollerY)];
    self.scroller.backgroundColor = [UIColor clearColor];
    
    self.t_settingsContentView = [SettingsContentView tt_viewFromNibNamed:@"SettingsContentView" owner:self];
    self.t_settingsContentView.backgroundColor = [UIColor clearColor];
    [self.t_settingsContentView addTarget:self action:@selector(dismissKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
    __weak SettingViewController *weakSelf = self;
    self.t_settingsContentView.pushDetailViewBlock = ^(int row)
    {
        [weakSelf pushDetail:row];
    };
    
    [self.t_settingsContentView.headPortaitBtn.layer setMasksToBounds:YES];
    self.t_settingsContentView.headPortaitBtn.layer.cornerRadius = self.t_settingsContentView.headPortaitBtn.frame.size.width/2;
    
    self.scroller.contentSize = CGSizeMake(self.view.frame.size.width, self.t_settingsContentView.frame.size.height);
    [self.scroller addSubview:self.t_settingsContentView];
    [self.view addSubview:self.scroller];
    
    
    
    
}

#pragma mark - User Interaction Helper
- (void)btnMenu:(id)sender
{
    if(self.delegate != nil) {
        
        [self.delegate onBtnMenuClick];
        [self dismissKeyBoard:nil];
    }
}

- (void)dismissKeyBoard:(id)sender
{
    [self.t_settingsContentView.firstNameField resignFirstResponder];
    [self.t_settingsContentView.lastNameField resignFirstResponder];
}

-(IBAction) logout:(id)sender
{
    [[UserModel getInstance] setLoginUser:nil];

    [[UserSetting getInstance] reset];
    [[CoreDataModel getInstance] reset];
    
    RootNavContrller *navController = [RootNavContrller defaultInstance];

        
    [navController popToRootViewControllerAnimated:NO];

    LoginMainViewController* loginController = [[LoginMainViewController alloc] init];
    [navController pushViewController:loginController animated:NO];
}

- (void)pushDetail:(int)row
{
    [self dismissKeyBoard:nil];
    
    if (row == emailViewTag
        ||row == pwdViewTag
        ||row == connectFacebookBtnTag
        ||row == connectGoogleBtnTag
        ||row == notificationViewTag
        ||row == termViewTag
        ||row == policyViewTag
        ||row == aboutUsViewTag
        )
    {
        UIViewController *viewCtr = nil;
        switch (row)
        {
            case emailViewTag:
                viewCtr = [[EmailChangeViewController alloc] initWithNibName:@"EmailChangeViewController" bundle:[NSBundle mainBundle]];
                break;
            case pwdViewTag:
                viewCtr = [[PwdChangeViewController alloc] initWithNibName:@"PwdChangeViewController" bundle:[NSBundle mainBundle]];
                break;
            case connectFacebookBtnTag:
                viewCtr = [[ConnectAccountViewController alloc] initWithNibName:@"ConnectAccountViewController" bundle:[NSBundle mainBundle]];
                [(ConnectAccountViewController *)viewCtr setType:ConnectFacebook];
                break;
            case connectGoogleBtnTag:
                viewCtr = [[ConnectAccountViewController alloc] initWithNibName:@"ConnectAccountViewController" bundle:[NSBundle mainBundle]];
                [(ConnectAccountViewController *)viewCtr setType:ConnectGoogle];
                break;
            case notificationViewTag:
                viewCtr = [[NotificaitonViewController alloc] initWithNibName:@"NotificaitonViewController" bundle:[NSBundle mainBundle]];

                break;
            case termViewTag:
                viewCtr = [[LegalViewController alloc] initWithNibName:@"LegalViewController" bundle:[NSBundle mainBundle]];
                [(LegalViewController *)viewCtr setType:TermsOfUs];
                break;
            case policyViewTag:
                viewCtr = [[LegalViewController alloc] initWithNibName:@"LegalViewController" bundle:[NSBundle mainBundle]];
                [(LegalViewController *)viewCtr setType:PrivacyPolicy];
                break;
            case aboutUsViewTag:
                viewCtr = [[LegalViewController alloc] initWithNibName:@"LegalViewController" bundle:[NSBundle mainBundle]];
                [(LegalViewController *)viewCtr setType:AboutUs];
                break;
            default:
                break;
        }
        
        [[RootNavContrller defaultInstance] pushViewController:viewCtr animated:YES];
    }

    else if (row == logoutBtnTag || row == deleteAccountBtnTag)
    {
        NSString *destructiveButtonTitle = row==logoutBtnTag ? @"Log Out":@"Delete Account";
    
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil];
        [sheet showInView:self.view];
    }
    else if (row == fbViewTag || row == googleViewTag)
    {
        [self createActionSheetWithRow:row];
    }
    else if (row == sendFeedBackBtnTag)
    {
        [self   sendEmail];
    }
    else if (row == headPortraitBtnTag)
    {
        [self createActionSheetWithRow:headPortraitBtnTag];
    }
    
}

#pragma mark - Logic Helper
-(void)sendEmail
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailView = [[MFMailComposeViewController alloc] init];

        mailView.mailComposeDelegate = self;
        [mailView setSubject:@"Calvin Feedback"];
        [mailView setToRecipients:@[@"feedback@calvinapp.com"]];
        [self presentViewController:mailView animated:YES completion:nil];
        
    }
    else
    {
        
    }
}

- (void)createActionSheetWithRow:(int)row
{
    UIActionSheet *sheet = nil;
    if (row == headPortraitBtnTag)
    {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Picker Photo From Album" otherButtonTitles:@"Picker Photo From Camera", nil];

    }
    else
    {
        NSString *destructiveButtonTitle = row==fbViewTag ? @"Unlink Facebook":@"Unlink Google";
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil];
    }
    
    sheet.tag = row;
    [sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.tag == headPortraitBtnTag)
    {
        if (buttonIndex == 0) {
            [self getImageFrom:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        else if(buttonIndex == 1)
        {
            [self getImageFrom:UIImagePickerControllerSourceTypeCamera];
        }
    }
    
}

- (void)getImageFrom:(UIImagePickerControllerSourceType)type
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = type;
    ipc.delegate = self;
    [self presentModalViewController:ipc animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    CGSize targetSize = self.t_settingsContentView.headPortaitBtn.frame.size;
    UIImage * newImage = [ViewUtils imageByScalingAndCroppingForSize:targetSize andUIImage:image];
    
    [self.t_settingsContentView.headPortaitBtn setImage:newImage forState:UIControlStateNormal];
    [picker dismissModalViewControllerAnimated:YES];
    
    [self uploadImage:newImage];
}

-(void) uploadImage:(UIImage *) img
{
    
    if(self.request != nil)
    {
        [self.request cancel];
        self.request = nil;
    }
    
    self.request =[[Model getInstance] uploadImage:img andCallback:self];
}

-(void) onUploadStart
{
    
}

-(void) onUploadProgress: (long long) progress andSize: (long long) Size
{
    float prg = (float)progress / (float)Size;
    //self.t_settingsContentView.headPortaitBtn.alpha = 0.3 + prg*0.7;
    LOG_D(@"onUploadProgress: progress=%f", prg);
}

-(void) onUploadCompleted: (int) error andUrl:(NSString *) url
{
    LOG_D(@"onUploadCompleted: url=%@", url);
    
    //self.t_settingsContentView.headPortaitBtn.alpha = 1;
    
    if(error == 0)
    {
        self.loginUser.avatar_url = url;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Upload Failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        [self.t_settingsContentView.headPortaitBtn setImage:[UIImage imageNamed:@"settings_main_head_portait_default"] forState:UIControlStateNormal];
    }
}

#pragma mark - Data Helper
- (void)getUserInfo
{
    //self.loginUser = [[UserSetting getInstance] getLoginUserData];
    self.loginUser  = [[UserModel getInstance] getLoginUser];
}

- (void)setValueForViews
{
    self.t_settingsContentView.firstNameField.text = self.loginUser.first_name;
    self.t_settingsContentView.lastNameField.text = self.loginUser.last_name;
    self.t_settingsContentView.emailLabel.text = self.loginUser.email;
    
    [self.t_settingsContentView.headPortaitBtn setImageWithURL:[NSURL URLWithString:self.loginUser.avatar_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"settings_main_head_portait_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        if (error)
        {
            [self.t_settingsContentView.headPortaitBtn setImage:[UIImage imageNamed:@"settings_main_head_portait_default"] forState:UIControlStateNormal];
            LOG_D(@"get avatar from remote failed.");
        }
    }];

}

#pragma mark - MFMailComposeViewControllerDelegate
- (void) mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
            
        default:
            break;
    }
 
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
