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
@interface SettingViewController ()<MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UIScrollView *scroller;
@property (nonatomic, strong) SettingsContentView *t_settingsContentView;
@property (nonatomic, strong) User *loginUser;
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
    if (row == emailViewTag
        ||row == pwdViewTag
        ||row == connectFacebookBtnTag
        ||row == connectGoogleBtnTag
        
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
                
                break;
            case termViewTag:
                
                break;
            case policyViewTag:
                
                break;
            case aboutUsViewTag:
                
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
         NSString *destructiveButtonTitle = row==fbViewTag ? @"Unlink Facebook":@"Unlink Google";
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil];
        [sheet showInView:self.view];
    }
    else if (row == sendFeedBackBtnTag)
    {
        [self   sendEmail];
    }
    
}

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
#pragma mark - Data Helper

- (void)getUserInfo
{
    self.loginUser = [[UserSetting getInstance] getLoginUserData];
}

- (void)setValueForViews
{
    self.t_settingsContentView.firstNameField.text = self.loginUser.first_name;
    self.t_settingsContentView.lastNameField.text = self.loginUser.last_name;
    self.t_settingsContentView.emailLabel.text = self.loginUser.email;
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
