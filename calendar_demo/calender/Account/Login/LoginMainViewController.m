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

@interface LoginMainViewController ()<LoginMainAccessViewDelegate,LoginMainCreatViewDelegate,LoginMainSignInViewDelegate,ShareLoginDelegate, GPPSignInDelegate>
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
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 568);
    [self.view addSubview:scrollView];
    
    titleView = [LoginMainTitileView creatView];
    [scrollView addSubview:titleView];
    CGRect frame = titleView.frame;
    frame.origin.y = 20;
    titleView.frame = frame;
    
    btnBack = [[UIButton alloc] initWithFrame:CGRectMake(18, 18, 21, 21)];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"event_detail_nav_back.png"] forState:UIControlStateNormal];
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
    [scrollView addSubview:creatView];
    creatView.delegate = self;
    CGRect frame = creatView.frame;
    frame.origin.y = titleView.frame.size.height + titleView.frame.origin.y + 20;
    creatView.frame = frame;
    [creatView setAlpha:0.0f];
}

- (void)configSignInView
{
    signInView = [LoginMainSignInView creatView];
    [scrollView addSubview:signInView];
    signInView.delegate = self;
    CGRect frame = signInView.frame;
    frame.origin.y = self.view.frame.size.height - frame.size.height - 15;
    signInView.frame = frame;
    [signInView setAlpha:0.0f];
}

- (void)backToAccessView
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        if (!creatView.hidden) {
            creatView.alpha = 0.0f;
        }
        if (!signInView.hidden) {
            signInView.alpha = 0.0f;
        }
        btnBack.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
            accessView.alpha = 1.0f;
        } completion:nil];
    }];
}

- (void)switchToCreatView
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        accessView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
            creatView.alpha = 1.0f;
            btnBack.alpha = 1.0f;
        } completion:nil];
    }];
}

- (void)switchToSignInView
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        accessView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
            btnBack.alpha = 1.0f;
            signInView.alpha = 1.0f;
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

- (void)btnSignUpDidClickWithName:(NSString *)name Email:(NSString *)_email Password:(NSString *)_password HeadPhoto:(UIImage *)headPhoto
{
    NSString * username = name;
    NSString * email = _email;
    NSString * password = _password;
    //{"username":"user1", "password":"111111", "email":"user1@pencilme.com"}
    
    CreateUser * user = [[CreateUser alloc] init];
    user.username = username;
    user.email = email;
    user.password = password;
    
    if (username == nil || password == nil || email == nil) {
        [self showAlert:@"can't be empty !!"];
        return;
    }
    
    [loadingView startAnimating];
    
    [[UserModel getInstance] createUser:user andCallback:^(NSInteger error, NSString * msg) {
        [loadingView stopAnimating];

        if(error == 0) {
            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@""
                                                          message:@"Success！"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
            [alert show];
        } else {
            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@""
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
    
    //[loadingView startAnimating];
    
    [signInView showLogining:YES];
    [[UserModel getInstance] login:username withPassword:password andCallback:^(NSInteger error, User *user) {
        
        //[loadingView stopAnimating];
        
        [signInView showLogining:NO];
        
        if(error == 0) {
            [self onLogined];
        } else {
            [self showAlert:@"Login failed！"];
        }
    }];
}

- (void)btnForgotPasswordDidClick
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Forgot Password" message:@"Enter the email associated with your account and we’ll send you a reset password link\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    

    
//    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
    
    self.alertTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 120.0, 260.0, 25)];
    [self.alertTextField setBackgroundColor:[UIColor whiteColor]];
    [self.alertTextField setPlaceholder:@"email"];
    [alertView addSubview:self.alertTextField];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSLog(@"%@", self.alertTextField.text);
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
