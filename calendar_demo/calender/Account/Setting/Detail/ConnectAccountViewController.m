//
//  ConnectAccountViewController.m
//  Calvin
//
//  Created by tu changwei on 13-9-27.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "ConnectAccountViewController.h"
#import "UserModel.h"
#import "ShareLoginFacebook.h"
#import "LoginStatusCheck.h"
#import "LoginAccountStore.h"

#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

@interface ConnectAccountViewController ()<GPPSignInDelegate>

@end

@implementation ConnectAccountViewController

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
    [self connectSocialNet];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup Views
- (void)setupViews
{
    NSString *title = @"";
    switch (self.type)
    {
        case ConnectFacebook:
            title = @"Facebook";
            break;
        case ConnectGoogle:
            title = @"Google";
            break;
        default:
            break;
    }
    self.navigation.titleLable.text = title;
    self.navigation.leftBtn.frame = CGRectMake(8, 9, 67, 26);
    [self.navigation.leftBtn setBackgroundImage:[UIImage imageNamed:@"settings_detail_cancel_btn"] forState:UIControlStateNormal];
    [self.navigation.leftBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    self.navigation.rightBtn.hidden = YES;
}
#pragma mark - Connect Helper
- (void)connectSocialNet
{
    switch (self.type)
    {
        case ConnectFacebook:
            [self connectFacebook];
            break;
            
        default:
            [self connectGoogle];
            break;
    }
}

- (void)connectGoogle
{
    [self configGPPSignIn];
    [[GPPSignIn sharedInstance] signOut];
    [[GPPSignIn sharedInstance] authenticate];
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
- (void)connectFacebook
{
    
}

#pragma mark GPPSignInDelegate
- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth
                   error:(NSError *)error
{
    LOG_D(@"finishedWithAuth:%@", error);
    
    if(error == nil) {
//        NSString  * acesssToken  = auth.accessToken;
//        LOG_D(@"Google acesssToken:%@, client secet=%@", acesssToken, auth.clientSecret);
//        //[loadingView startAnimating];
//        [[UserModel getInstance] signinGooglePlus:acesssToken andCallback:^(NSInteger error, User *user) {
//            
//            LOG_D(@"signinGooglePlus:%d", error);
//            
//            
//            //[loadingView stopAnimating];
//            
//            if(error == 0) {
//                //[self onLogined];
//                
//            } else {
//                //[self showAlert:@"Login with google failed."];
//            }
//        }];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        LOG_D(@"%@",error);
    }
}

- (void)didDisconnectWithError:(NSError *)error
{
    LOG_D(@"didDisconnectWithError:%@", error);
}

@end
