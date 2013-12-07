//
//  LoginMainViewController.m
//  login
//
//  Created by zyax86 on 9/23/13.
//  Copyright (c) 2013 zyax86. All rights reserved.
//

#import "LoginMainViewController.h"
#import "LoginMainTitileView.h"
#import "LoginMainAccessView.h"
#import "LoginMainCreatView.h"
#import "LoginMainSignInView.h"


#import "MainViewController.h"
#import "RootNavContrller.h"
#import "UserModel.h"
#import "ShareLoginFacebook.h"
#import "LoginStatusCheck.h"
#import "LoginAccountStore.h"

#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

#import "TPKeyboardAvoidingScrollView.h"

#import "Utils.h"
#import "SysInfo.h"

@interface LoginMainViewController ()<LoginMainAccessViewDelegate,LoginMainCreatViewDelegate,LoginMainSignInViewDelegate,ShareLoginDelegate, GPPSignInDelegate, UIAlertViewDelegate>
{
    
    UIImageView *bgView;
    TPKeyboardAvoidingScrollView *scrollView;
    LoginMainTitileView *titleView;
    UIButton *btnBack;
    
    LoginMainAccessView *accessView;
    LoginMainCreatView *creatView;
    LoginMainSignInView *signInView;
    
    
    ShareLoginFacebook * snsLogin;
    int loginType;
    UIActivityIndicatorView * loadingView;
}

@property(nonatomic, strong) UITextField *alertTextField;

@end

@implementation LoginMainViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_mainview_bg.jpg"]];
    [self.view addSubview:bgView];
    [bgView setContentMode:UIViewContentModeScaleAspectFill];
    [bgView setFrame:self.view.bounds];
    
    scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:scrollView];
    
    titleView = [LoginMainTitileView creatView];
    [scrollView addSubview:titleView];
    CGRect frame = titleView.frame;
    frame.origin.y = 20;
    titleView.frame = frame;
    
    btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    btnBack.contentEdgeInsets = UIEdgeInsetsMake(11, 11, 11, 11);
    [btnBack setImage:[UIImage imageNamed:@"event_detail_nav_back.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:btnBack];
    [btnBack addTarget:self action:@selector(backToAccessView) forControlEvents:UIControlEventTouchUpInside];
    [btnBack setAlpha:0.0f];
    
    loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadingView.center = self.view.center;
    loadingView.hidesWhenStopped = YES;
    [self.view addSubview:loadingView];
    
    [self configGPPSignIn];
    [self configAccessView];
    [self configCreatView];
    [self configSignInView];
    
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

- (void)configAccessView
{
    accessView = [LoginMainAccessView creatView];
    [scrollView addSubview:accessView];
    accessView.delegate = self;
    CGRect frame = accessView.frame;
    frame.origin.y = self.view.bounds.size.height - frame.size.height - 20;
    accessView.frame = frame;
}

- (void)configCreatView
{
    creatView = [LoginMainCreatView creatView];
    creatView.delegate = self;
    CGRect frame = creatView.frame;
    frame.origin.y = titleView.frame.size.height + titleView.frame.origin.y + 20;
    creatView.frame = frame;
    [creatView setAlpha:0.0f];
}

- (void)configSignInView
{
    signInView = [LoginMainSignInView creatView];
    signInView.delegate = self;
    CGRect frame = signInView.frame;
    frame.origin.y = self.view.frame.size.height - frame.size.height - 15;
    signInView.frame = frame;
    [signInView setAlpha:0.0f];
    
    [signInView fillSavedEmail];
}

- (void)backToAccessView
{
    [self.view endEditing:YES];
    [scrollView addSubview:accessView];
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        if (!creatView.hidden) {
            creatView.alpha = 0.0f;
        }
        if (!signInView.hidden) {
            signInView.alpha = 0.0f;
        }
        btnBack.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [creatView removeFromSuperview];
        [signInView removeFromSuperview];
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
            accessView.alpha = 1.0f;
            [scrollView setContentSize:CGSizeMake(320, accessView.frame.size.height + accessView.frame.origin.y)];
        } completion:nil];
    }];
}

- (void)switchToCreatView
{
    [scrollView addSubview:creatView];
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        accessView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [accessView removeFromSuperview];
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
            btnBack.alpha = 1.0f;
            creatView.alpha = 1.0f;
            [scrollView setContentSize:CGSizeMake(320, creatView.frame.size.height + creatView.frame.origin.y)];
        } completion:nil];
    }];
}

- (void)switchToSignInView
{
    
    [scrollView addSubview:signInView];
    [signInView fillSavedEmail];
    
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        accessView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [accessView removeFromSuperview];
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
            btnBack.alpha = 1.0f;
            signInView.alpha = 1.0f;
            [scrollView setContentSize:CGSizeMake(320, signInView.frame.size.height + signInView.frame.origin.y)];
        } completion:nil];
    }];
}

-(void) swithFromCreateViewToSigninView
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        creatView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [creatView removeFromSuperview];
        [scrollView addSubview:signInView];
        [signInView fillSavedEmail];
        
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
            btnBack.alpha = 1.0f;
            signInView.alpha = 1.0f;
            [scrollView setContentSize:CGSizeMake(320, signInView.frame.size.height + signInView.frame.origin.y)];
        } completion:nil];
    }];
}

-(void)signupGoogle {
    //TODO::
    loginType = 2;
    
    [[GPPSignIn sharedInstance] signOut];
    [[GPPSignIn sharedInstance] authenticate];
}

-(void)signupFacebook {
    
    loginType = 1;
    
    if(![LoginStatusCheck isFacebookAccountLoginIn])
    {
        snsLogin = [[ShareLoginFacebook alloc]init];
        snsLogin.delegate = self;
        [snsLogin shareLogin];
    }
    else
    {
        [self shareDidLogin:nil];
    }
}



-(void) onLogined
{
    MainViewController *rootController = [[MainViewController alloc] init];
    
    [[RootNavContrller defaultInstance] popViewControllerAnimated:NO];
    [[RootNavContrller defaultInstance] pushViewController:rootController animated:YES];
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

#pragma mark -
#pragma mark LoginMainAccessViewDelegate
- (void)btnSignUpSelected
{
    [self switchToCreatView];
}

- (void)btnSignInSelected
{
    [self switchToSignInView];
}

#pragma mark -
#pragma mark LoginMainCreatViewDelegate

- (void)btnFacebookSignUpDidClick
{
    [self signupFacebook];
}

- (void)btnGoogleSignUpDidClick
{
    [self signupGoogle];
}

- (void)btnSignUpDidClickWithName:(CreateUser *) createUser
{
    if (createUser.email == nil || createUser.password == nil) {
        [self showAlert:@"Email and Password can't be empty !!"];
        return;
    }
    
    
    
    
    
    [creatView showLoadingAnimation:YES];
    
    [[UserModel getInstance] createUser:createUser andCallback:^(NSInteger error, NSString * msg) {
        
        [creatView showLoadingAnimation:NO];
    
        if(error == 0) {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@""
//                                                          message:@"Success！"
//                                                         delegate:self
//                                                cancelButtonTitle:@"OK"
//                                                otherButtonTitles:nil];
//            
//            alert.tag = 1;
//            [alert show];
            
            [signInView setEmail:createUser.email andPass:createUser.password];
            [self btnSignInDidClickWithName:createUser.email Password:createUser.password];
            
        } else {
            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                          message:msg
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
            [alert show];
        }
    }];
}

#pragma mark -
#pragma mark LoginMainSignInViewDelegate

- (void)btnFacebookSignInDidClick
{
    [self signupFacebook];
}

- (void)btnGoogleSignInDidClick
{
    [self signupGoogle];
}

- (void)btnSignInDidClickWithName:(NSString *)name Password:(NSString *)_password
{
    NSString * username = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * password = _password;
    if (username.length == 0 || password.length == 0) {
        [self showAlert:@"Email and password can't be empty!"];
        return;
    }
    
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults setObject:username forKey:@"email"];
    [accountDefaults synchronize];
    
    //[loadingView startAnimating];
    
    [signInView showLogining:YES];
    [[UserModel getInstance] login:username withPassword:password andCallback:^(NSInteger error, User *user) {
        
        //[loadingView stopAnimating];
        
        [signInView showLogining:NO];
        
        if(error == 0) {
            [self onLogined];
        } else {
            [Utils showUIAlertView:@"Error" andMessage:@"Email or password error."];
        }
    }];
}

- (void)btnForgotPasswordDidClick
{
    NSString * email = [signInView getEmail];
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
        [alertTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
       
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
        
        self.alertTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 120.0, 260.0, 30)];
        [self.alertTextField setBorderStyle:UITextBorderStyleRoundedRect];
        [self.alertTextField setBackgroundColor:[UIColor whiteColor]];
        [self.alertTextField setPlaceholder:@"Please input your email"];
        
        if(email != nil) {
            self.alertTextField.text = email;
        }
        
        [self.alertTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        [alertView addSubview:self.alertTextField];
    }
}

- (void) textFieldDidChange:(UITextField *) TextField
{
    if ([Utils isValidateEmail:TextField.text]) {
        TextField.textColor = [UIColor blackColor];
    } else {
        TextField.textColor = [UIColor redColor];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1) {
        //Create new user success;
        [self swithFromCreateViewToSigninView];
    } else {
        if (buttonIndex == 1) {

            NSString * email;
            if(([SysInfo version] >= 7.0)) {
                email = [alertView textFieldAtIndex:0].text;
            } else {
                email = self.alertTextField.text;
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

#pragma mark -
#pragma mark GPPSignInDelegate
- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth
                   error:(NSError *)error
{
    LOG_D(@"finishedWithAuth:%@", error);
    
    if(error == nil) {
        NSString  * acesssToken  = auth.accessToken;
        LOG_D(@"Google acesssToken:%@, client secet=%@", acesssToken, auth.clientSecret);
        [loadingView startAnimating];
        [[UserModel getInstance] signinGooglePlus:acesssToken andCallback:^(NSInteger error, User *user) {
            
            LOG_D(@"signinGooglePlus:%d", error);
            
            
            [loadingView stopAnimating];
            
            if(error == 0) {
                [self onLogined];
            } else {
                [self showAlert:@"Login with google failed."];
            }
        }];
        
    } else {
        [self showAlert:@"Google+ auth failed, please retry again!"];
    }
}

- (void)didDisconnectWithError:(NSError *)error
{
    LOG_D(@"didDisconnectWithError:%@", error);
}

@end
