//
//  LoginViewController.m
//  Calvin
//
//  Created by Kevin Wu on 3/4/14.
//  Copyright (c) 2014 Pencil Me, Inc. All rights reserved.
//
#define LOGO_WIDTH 156
#define LOGO_HEIGHT 158

#define BANNER_WIDTH 200
#define BANNER_HEIGHT 69
#import "LoginViewController.h"
#import "UIColor+Hex.h"
#import "EmailLoginViewController.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "ShareLoginFacebook.h"
#import "Utils.h"
#import "UserModel.h"
#import "CoreDataModel.h"
#import "UserSetting.h"
#import "LoadingEventViewController.h"
#import "RootNavContrller.h"
#import "MainViewController.h"
#import "SysInfo.h"
#import "LoginAccountStore.h"


@interface LoginViewController () <GPPSignInDelegate,LoginViewControllerDelegate, ShareLoginDelegate>
{
    UIView *navView;
    UIButton *leftBtn;
    UILabel *labelTitle;
    UIImageView *bgView;
    UIImageView *logoView;
    UIImageView *bannerView;
    //UILabel *textLabel;
    UIButton *fbLoginBtn;
    UIButton *gLoginBtn;
    UIButton *emailLoginBtn;
    
    ShareLoginFacebook * snsLogin;
    int loginType;
    UIActivityIndicatorView *loadingView;
}
@end

@implementation LoginViewController

-(id)init
{
    self = [super init];
    if (self) {
        [self configGPPSignIn];
    }
    return self;
}

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
    
    
	bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feed_background_image.png"]];
    [bgView setFrame:CGRectMake(0, -5, self.view.bounds.size.width, self.view.bounds.size.height +6)];
    [self.view addSubview:bgView];
    
    navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    [navView setBackgroundColor:[UIColor generateUIColorByHexString:@"#18a48b"]];
    
    leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(14, 20, 80, 44)];
    UIFont *navBtnFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    [leftBtn setTitle:@"Back" forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(-2, -5, 0, 0)];
    [leftBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [leftBtn.titleLabel setFont:navBtnFont];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(onBackButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:leftBtn];
    
    labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    [labelTitle setBackgroundColor:[UIColor clearColor]];
    
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.lineBreakMode = NSLineBreakByWordWrapping;
    labelTitle.numberOfLines = 0;
    
    labelTitle.text = @"Log In";
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    [labelTitle setTextColor:[UIColor whiteColor]];
    //[labelTitle setFont:[UIFont boldSystemFontOfSize:14]];
    [navView addSubview:labelTitle];
    [self.view addSubview:navView];
    
    logoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"calvin_icon_large.png"]];
    
    int logoX = self.view.bounds.size.width/2 - LOGO_WIDTH/2;
    [logoView setFrame:CGRectMake(logoX, 100, LOGO_WIDTH, LOGO_HEIGHT)];
    [self.view addSubview:logoView];
    
    bannerView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"calvin_logo_large.png"]];
    
    int bannerX = self.view.bounds.size.width/2 - BANNER_WIDTH/2;
    [bannerView setFrame:CGRectMake(bannerX, 100 + LOGO_HEIGHT + 20, BANNER_WIDTH, BANNER_HEIGHT)];
    [self.view addSubview:bannerView];
    
//    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:22.0];
//    
//    textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
//    [textLabel setFont:font];
//    [textLabel setTextColor:[UIColor generateUIColorByHexString:@"1f1e1e"]];
//    [textLabel setText:@"More Plans,Less Planning."];
//    [textLabel sizeToFit];
//    [textLabel setTextAlignment:NSTextAlignmentCenter];
//    [textLabel setCenter:CGPointMake(self.view.center.x, bannerView.frame.origin.y + BANNER_HEIGHT + 30)];
//    [self.view addSubview:textLabel];
    
    
    
    gLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gLoginBtn.frame = CGRectMake(0, 0, 304, 45);
    UIColor *loginBtnBgColor = [UIColor generateUIColorByHexString:@"#df4a32"];
    [gLoginBtn setBackgroundColor:loginBtnBgColor];
    [gLoginBtn setTitle:@"Log in with" forState:UIControlStateNormal];
    UIFont *btnFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
    [[gLoginBtn titleLabel]setFont:btnFont];
    [[gLoginBtn titleLabel] setTextColor:[UIColor whiteColor]];
    [gLoginBtn setCenter:CGPointMake(self.view.center.x, bannerView.frame.origin.y + 150)];
    CALayer *gLayer = [self getButtonSepLayer];
    [gLoginBtn.layer addSublayer:gLayer];
    [gLoginBtn setImage:[UIImage imageNamed:@"google_plus_icon.png"] forState:UIControlStateNormal];
    [gLoginBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -160, 0, 0)];
    [gLoginBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -100, 0, 0)];
    [gLoginBtn addTarget:self action:@selector(doLoginGoogle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gLoginBtn];
    
    UILabel *gLabel = [[UILabel alloc]initWithFrame:CGRectMake(gLoginBtn.frame.origin.x + 170, gLoginBtn.frame.origin.y + 10, 80, 23)];
    UIFont *btnFont2 = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0];
    [gLabel setText:@"Google"];
    [gLabel setTextColor:[UIColor whiteColor]];
    [gLabel setFont:btnFont2];
    [self.view addSubview:gLabel];
    
    fbLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fbLoginBtn.frame = CGRectMake(0, 0, 304, 45);
    UIColor *fbBtnBgColor = [UIColor generateUIColorByHexString:@"#3a5897" withAlpha:0.9];
    [fbLoginBtn setBackgroundColor:fbBtnBgColor];
    [fbLoginBtn setTitle:@"Log in with" forState:UIControlStateNormal];
    [[fbLoginBtn titleLabel]setFont:btnFont];
    [[fbLoginBtn titleLabel] setTextColor:[UIColor whiteColor]];
    [fbLoginBtn setCenter:CGPointMake(self.view.center.x, gLoginBtn.frame.origin.y + 75)];
    CALayer *fbLayer = [self getButtonSepLayer];
    [fbLoginBtn.layer addSublayer:fbLayer];
    [fbLoginBtn setImage:[UIImage imageNamed:@"facebook_icon.png"] forState:UIControlStateNormal];
    [fbLoginBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -160, 0, 0)];
    [fbLoginBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -100, 0, 0)];
    [fbLoginBtn addTarget:self action:@selector(doLoginFacebook) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fbLoginBtn];
    
    UILabel *fbLabel = [[UILabel alloc]initWithFrame:CGRectMake(fbLoginBtn.frame.origin.x + 165, fbLoginBtn.frame.origin.y + 10, 100, 23)];
    UIFont *btnFont3 = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0];
    [fbLabel setText:@"Facebook"];
    [fbLabel setTextColor:[UIColor whiteColor]];
    [fbLabel setFont:btnFont3];
    [self.view addSubview:fbLabel];
    
    emailLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    emailLoginBtn.frame = CGRectMake(0, 0, 304, 45);
    UIColor *emailBtnBgColor = [UIColor generateUIColorByHexString:@"#18a48b"];
    [emailLoginBtn setBackgroundColor:emailBtnBgColor];
    [emailLoginBtn setTitle:@"Log in with Email" forState:UIControlStateNormal];
    [[emailLoginBtn titleLabel]setFont:btnFont];
    [[emailLoginBtn titleLabel] setTextColor:[UIColor whiteColor]];
    [emailLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [emailLoginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [emailLoginBtn setCenter:CGPointMake(self.view.center.x, fbLoginBtn.frame.origin.y + 75)];
    CALayer *emailLayer = [self getButtonSepLayer];
    [emailLoginBtn.layer addSublayer:emailLayer];
    [emailLoginBtn setImage:[UIImage imageNamed:@"email_icon.png"] forState:UIControlStateNormal];
    [emailLoginBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -110, 0, 0)];
    [emailLoginBtn addTarget:self action:@selector(onEmailLoginBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:emailLoginBtn];
    
    loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadingView.center = self.view.center;
    loadingView.hidesWhenStopped = YES;
    [self.view addSubview:loadingView];
}

- (void)configGPPSignIn
{
    //Google sign in init
    GPPSignIn * signIn = [GPPSignIn sharedInstance];
    signIn.clientID = @"925583491857-13g9a7inud7m0083m5jfbjinn3mp58ch.apps.googleusercontent.com";
    //signIn.clientID = @"1031805047217.apps.googleusercontent.com";
    //signIn.clientID = @"413114824893.apps.googleusercontent.com";
    
    signIn.shouldFetchGoogleUserEmail = YES;
    
    signIn.actions = [NSArray arrayWithObjects:
                      @"http://schemas.google.com/AddActivity",
                      @"http://schemas.google.com/BuyActivity",
                      @"http://schemas.google.com/CheckInActivity",
                      @"http://schemas.google.com/CommentActivity",
                      @"http://schemas.google.com/CreateActivity",
                      @"http://schemas.google.com/ListenActivity",
                      @"http://schemas.google.com/ReserveActivity",
                      @"http://schemas.google.com/ReviewActivity",
                      nil];
    
    signIn.scopes = [NSArray arrayWithObjects:
                     kGTLAuthScopePlusLogin,
                     kGTLAuthScopePlusMe,
                     @"https://www.googleapis.com/auth/calendar",
                     @"https://www.googleapis.com/auth/userinfo.profile",
                     @"https://www.googleapis.com/auth/userinfo.email",
                     @"https://www.google.com/m8/feeds",
                     nil];
    signIn.delegate = self;
}

-(void) onLogined
{
    User *me = [[UserModel getInstance] getLoginUser];
    [[CoreDataModel getInstance] initDBContext:me];
    
    NSString * last_modify_num = [[UserSetting getInstance] getStringValue:KEY_LASTUPDATETIME];
    
    if(last_modify_num == nil) {
        LoadingEventViewController *rootController = [[LoadingEventViewController alloc] init];
        [[RootNavContrller defaultInstance] popViewControllerAnimated:NO];
        [[RootNavContrller defaultInstance] pushViewController:rootController animated:YES];
        
    } else {
        
        MainViewController * rootController = [[MainViewController alloc] init];
        
        [[RootNavContrller defaultInstance] popToRootViewControllerAnimated:NO];
        [[RootNavContrller defaultInstance] pushViewController:rootController animated:YES];
    }
}

-(void) showAlert:(NSString *) msg
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)doSignupGoogle
{
    [self doLoginGoogle];
}

-(void)doSignupFacebook
{
    [self doLoginFacebook];
}

- (void)doSignupWithUser:(CreateUser *) createUser
{
    if (createUser.email == nil || createUser.password == nil) {
        [self showAlert:@"Email and Password can't be empty !!"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINSUCCESS" object:nil];
        return;
    }
    
    
    
    
    
    //[creatView showLoadingAnimation:YES];
    
    [[UserModel getInstance] createUser:createUser andCallback:^(NSInteger error, NSString * msg) {
        
        //[creatView showLoadingAnimation:NO];
        
        if(error == 0) {
            //            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@""
            //                                                          message:@"Success！"
            //                                                         delegate:self
            //                                                cancelButtonTitle:@"OK"
            //                                                otherButtonTitles:nil];
            //
            //            alert.tag = 1;
            //            [alert show];
            
            //[signInView setEmail:createUser.email andPass:createUser.password];
            [self doLoginWithEmail:createUser.email password:createUser.password];
            
        } else {
            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                          message:msg
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
            [alert show];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINSUCCESS" object:nil];
    }];
}

- (void)doLoginWithEmail:(NSString *)name password:(NSString *)_password
{
    NSString * username = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * password = _password;
    if (username.length == 0 || password.length == 0) {
        [self showAlert:@"Email and password can't be empty!"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"LOGINSUCCESS" object:nil];
        return;
    }
    
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setObject:username forKey:@"email"];
    [accountDefaults synchronize];
    
    //[loadingView startAnimating];
    
    //[signInView showLogining:YES];
    [[UserModel getInstance] login:username withPassword:password andCallback:^(NSInteger error, User *user) {
        
        //[loadingView stopAnimating];
        
        //[signInView showLogining:NO];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"LOGINSUCCESS" object:nil];
        if(error == 0) {
            [self onLogined];
        } else {
            [Utils showUIAlertView:@"Error" andMessage:@"Email or password error."];
        }
    }];
}

- (void)doFogotPassword
{
    //NSString * email = [signInView getEmail];
    NSString * email = @"";
    if(email == nil || email.length == 0)
    {
        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        email = [accountDefaults objectForKey:@"email"];
    }
    
    if([SysInfo version] >= 7.0) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Forgot Password"
                                                            message:@"Enter the email associated with your account and we’ll send you a reset password link."
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"OK", nil];
        
        CGRect frame = alertView.frame;
        frame.size.height = 300;
        alertView.frame = frame;
        
        [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [alertView show];
        
        UITextField * alertTextField = [alertView textFieldAtIndex:0];
        
        
        [alertTextField setPlaceholder:@"Please input your email"];
        alertTextField.keyboardType = UIKeyboardTypeEmailAddress;
        alertTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        //[alertTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        
        if(email != nil) {
            alertTextField.text = email;
        }
        
    } else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Forgot Password"
                                                            message:@"Enter the email associated with your account and we’ll send you a reset password link\n\n\n"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"OK", nil];
        
        
        [alertView show];
        
//        self.alertTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 120.0, 260.0, 30)];
//        [self.alertTextField setBorderStyle:UITextBorderStyleRoundedRect];
//        [self.alertTextField setBackgroundColor:[UIColor whiteColor]];
//        self.alertTextField.keyboardType = UIKeyboardTypeEmailAddress;
//        self.alertTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//        [self.alertTextField setPlaceholder:@"Please input your email"];
        
        if(email != nil) {
            //self.alertTextField.text = email;
        }
        
        //[self.alertTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        //[alertView addSubview:self.alertTextField];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1) {
        //Create new user success;
        //[self swithFromCreateViewToSigninView];
    } else {
        if (buttonIndex == 1) {
            
            NSString * email;
            if(([SysInfo version] >= 7.0)) {
                email = [alertView textFieldAtIndex:0].text;
            } else {
                //email = self.alertTextField.text;
            }
            
            NSLog(@"%@", email);
            
            [[UserModel getInstance] resetpassword:email andCallback:^(NSInteger error) {
                
                if(error == 0) {
                    
                    NSString * msg = @"We have sent you an e-mail. If you do not receive it within a few minutes, contact us at feedback@calvinapp.com";
                    [Utils showUIAlertView:@"" andMessage:msg];
                    
                } else {
                    [Utils showUIAlertView:@"Warning" andMessage:@"Reset password failed, please try again."];
                }
            }];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CALayer *)getButtonSepLayer
{
    CALayer *sepLayer = [CALayer layer];
    [sepLayer setFrame:CGRectMake(45, 0, 1, 45)];
    [sepLayer setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.3].CGColor];
    return sepLayer;
}

-(void)onBackButtonTapped
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)onEmailLoginBtnTapped
{
    EmailLoginViewController *email = [[EmailLoginViewController alloc]init];
    [email setDelegate:self];
    [self.navigationController pushViewController:email animated:YES];
}


-(void)doLoginGoogle {
    //TODO::
    loginType = 2;
    
    [[GPPSignIn sharedInstance] signOut];
    [[GPPSignIn sharedInstance] authenticate];
}

-(void)doLoginFacebook {
    
    loginType = 1;
    
    //    if (FBSession.activeSession.isOpen) {
    //        // if a user logs out explicitly, we delete any cached token information, and next
    //        // time they run the applicaiton they will be presented with log in UX again; most
    //        // users will simply close the app or switch away, without logging out; this will
    //        // cause the implicit cached-token login to occur on next launch of the application
    //        [[FBSession activeSession] closeAndClearTokenInformation];
    //        [[FBSession activeSession] close];
    //    }
    
    [[FBSession activeSession] closeAndClearTokenInformation];
    // Create a new, logged out session.
    NSArray *permissions = [NSArray arrayWithObjects:
                            @"email",
                            @"user_likes",
                            @"publish_actions",
                            @"publish_stream",
                            nil];
    FBSession *session = [[FBSession alloc] initWithPermissions:permissions];
    [FBSession setActiveSession:session];
    
    NSString *fbAppUrl = @"fbauth2://authorize";
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:fbAppUrl]])
    {
        
        [[FBSession activeSession] openWithCompletionHandler:^(FBSession *session,
                                                               FBSessionState status,
                                                               NSError *error)
         {
             if(status == FBSessionStateOpen) {
                 [self loginResult:session statue:status Error:error];
             }
         }];
    }
    else
    {
        snsLogin = [[ShareLoginFacebook alloc] init];
        snsLogin.delegate = self;
        [snsLogin shareLogin];
    }
    
    //    if(![LoginStatusCheck isFacebookAccountLoginIn])
    //    {
    //
    //        NSString *fbAppUrl = @"fbauth2://authorize";
    //        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:fbAppUrl]])
    //        {
    //
    //            [[FBSession activeSession] openWithCompletionHandler:^(FBSession *session,
    //                                                                   FBSessionState status,
    //                                                                   NSError *error)
    //             {
    //                 //[self loginResult:session statue:status Error:error];
    //             }];
    //        }
    //        else
    //        {
    //            snsLogin = [[ShareLoginFacebook alloc] init];
    //            snsLogin.delegate = self;
    //            [snsLogin shareLogin];
    //        }
    //
    //    }
    //    else
    //    {
    //        [self shareDidLogin:nil];
    //    }
}


- (void)loginResult:(FBSession *)session statue:(FBSessionState) status Error:(NSError *)error
{
    LOG_D(@"facebook loginResult:%d, error=%d, accesstoke=%@", status, error.code, session.accessToken);
    
    if(error.code == 0) {
        
        [self shareDidLogin:nil];
    } else {
        //TODO::
        [Utils showUIAlertView:@"Error" andMessage:@"Login with facebook account failed"];
    }
    //
    //    if(error.code == -1009)
    //    {//无网络
    //        LOG_D(@"error.code: -1009");
    //        if([self.delegate respondsToSelector:@selector(shareDidNotNetWork:)])
    //            [self.delegate shareDidNotNetWork:self];
    //    }
    //    else if(error.code == -1001)
    //    {//超时
    //        LOG_D(@"error.code: -1001");
    //        if([self.delegate respondsToSelector:@selector(shareDidLoginTimeOut:)])
    //            [self.delegate shareDidLoginTimeOut:self];
    //    }
    //    else if(error.code == -1003)
    //    {//找不到服务器
    //        LOG_D(@"error.code: -1003");
    //        if([self.delegate respondsToSelector:@selector(shareDidLoginTimeOut:)])
    //            [self.delegate shareDidLoginTimeOut:self];
    //    }
    //    else if(error.code != 0)
    //    {
    //        if([self.delegate respondsToSelector:@selector(shareDidLoginErr:)])
    //            [self.delegate shareDidLoginErr:self];
    //    }
    //    else
    //    {
    //        [self shareDidLogin:nil];
    //        
    //    }
}

#pragma mark -
#pragma mark ShareLoginDelegate
- (void)shareDidLogin:(ShareLoginBase *)shareLogin
{
    
    LoginAccountStore * store = [LoginAccountStore defaultAccountStore];
    
    if (1 == loginType) {
        NSString * accessToken = store.facebookAccessToken;
        
        LOG_D(@"shareDidLogin:%@", accessToken);
        
        [loadingView startAnimating];
        [[UserModel getInstance] signinFacebook:accessToken andCallback:^(NSInteger error, User *user) {
            
            [loadingView stopAnimating];
            
            LOG_D(@"signinFacebook:%d", error);
            
            if(error == 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINSUCCESS" object:nil];
                [self onLogined];
            } else {
                [self showAlert:@"Login with facebook failed."];
            }
        }];
    }
}

- (void)shareDidNotLogin:(ShareLoginBase *)shareLogin
{
    
}
- (void)shareDidNotNetWork:(ShareLoginBase *)shareLogin
{
    
}
- (void)shareDidLogout:(ShareLoginBase *)shareLogin
{
    
}
- (void)shareDidLoginErr:(ShareLoginBase *)shareLogin
{
    
}
- (void)shareDidLoginTimeOut:(ShareLoginBase *)shareLogin
{
    
}

-(void)switchInBusyMode
{
    [loadingView startAnimating];
    //[gLoginBtn setEnabled:NO];
    //[emailLoginBtn setEnabled:NO];
    //[fbLoginBtn setEnabled:NO];
}

#pragma mark -
#pragma mark GPPSignInDelegate
- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth
                   error:(NSError *)error
{
    LOG_D(@"finishedWithAuth:%@", error);
    
    if(error == nil) {
        NSString  * acesssToken  = auth.accessToken;
        LOG_D(@"Google acesssToken:%@, client secet=%@", acesssToken, auth.clientSecret);
        [self switchInBusyMode];
        
        [[UserModel getInstance] signinGooglePlus:acesssToken andRefeshToken:auth.refreshToken andCallback:^(NSInteger error, User *user) {
            
            LOG_D(@"signinGooglePlus:%d", error);
            
            
            [loadingView stopAnimating];
            
            if(error == 0) {
                [self onLogined];
            } else {
                [self showAlert:@"Login with google failed."];
            }
        }];
        
    } else if(error.code != -1) {
        
        [self showAlert:@"Google+ auth failed, please retry again!"];
        [self onLoginSuccess:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINSUCCESS" object:nil];
        
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINSUCCESS" object:nil];

    }
}

- (void)didDisconnectWithError:(NSError *)error
{
    LOG_D(@"didDisconnectWithError:%@", error);
}

-(void)onLoginSuccess:(NSNotification *) notification
{
    //[self.view setUserInteractionEnabled:YES];
    [loadingView stopAnimating];
    //[gLoginBtn setEnabled:YES];
    //[emailLoginBtn setEnabled:YES];
    //[fbLoginBtn setEnabled:YES];
}

@end
