//
//  SignupViewController.m
//  calender
//
//  Created by fang xiang on 13-6-8.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "SignupViewController.h"
#import "LoginView.h"

#import "FeedViewController.h"
#import "menuNavigation.h"
#import "DDMenuController.h"
#import "LoginNowController.h"

#import "RootNavContrller.h"
#import "UserModel.h"

#import "ShareLoginFacebook.h"
#import "LoginStatusCheck.h"
#import "LoginAccountStore.h"

@interface SignupViewController () <ShareLoginDelegate>

  

@end

@implementation SignupViewController {
    ShareLoginFacebook * snsLogin;
    int loginType;
    
    UIActivityIndicatorView * loadingView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = self.view.frame;
    LoginView * view = [LoginView createView];
    
    [view.signupGoogle addTarget:self action:@selector(signupGoogle) forControlEvents:UIControlEventTouchUpInside];
    [view.signupFacebook addTarget:self action:@selector(signupFacebook) forControlEvents:UIControlEventTouchUpInside];
    [view.signupEmail addTarget:self action:@selector(signupEmail) forControlEvents:UIControlEventTouchUpInside];

    view.loginnow.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(login)];
    [view.loginnow addGestureRecognizer:tapGes];
                                                                                                          
    
    CGRect frame2 = view.frame;
    frame2.origin.y  = (frame.size.height - frame2.size.height)/2;
    view.frame = frame2;
    
    [self.view addSubview: view];
    
    loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadingView.center = self.view.center;
    loadingView.hidesWhenStopped = YES;
    [self.view addSubview:loadingView];
}

-(void)login
{
    LoginNowController * ctrl = [[LoginNowController alloc] initWithNibName:@"LoginNowController" bundle:nil];
    [self.navigationController pushViewController:ctrl animated:YES];
}

-(void)signupGoogle {
    //TODO::
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

-(void) signupEmail {
    
    [self finish];

    [[UserModel getInstance] login:@"zhiwehu@gmail.com" withPassword:@"huzhiwei" andCallback:^(NSInteger error, User *user) {
        if(error == 0) {
            [self onLogined];
        } else {
            NSLog(@"error=%d", error);
        }
    }];
}

-(void) finish {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
//}



- (void)shareDidLogin:(ShareLoginBase *)shareLogin
{
    
    LoginAccountStore * store = [LoginAccountStore defaultAccountStore];
    
    if (1 == loginType) {
        NSString * accessToken = store.facebookAccessToken;
        
        NSLog(@"shareDidLogin:%@", accessToken);
        
        [loadingView startAnimating];
        [[UserModel getInstance] signinFacebook:accessToken andCallback:^(NSInteger error, User *user) {
            
            [loadingView stopAnimating];
            
            if(error == 0) {
                [self onLogined];
            } else {
                //TODO::
            }
        }];
    }
}

-(void) onLogined
{
    menuNavigation *leftController = [[menuNavigation alloc] init];
    FeedViewController * fdController = [[FeedViewController alloc] init];
    
    
    DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:fdController];
    rootController.leftViewController = leftController;
    
    fdController.delegate = rootController;
    
    [[RootNavContrller defaultInstance] popViewControllerAnimated:NO];
    [[RootNavContrller defaultInstance] pushViewController:rootController animated:YES];

}

- (void)shareDidNotLogin:(ShareLoginBase *)shareLogin
{
    NSLog(@"shareDidNotLogin");
}

- (void)shareDidNotNetWork:(ShareLoginBase *)shareLogin
{
    NSLog(@"shareDidNotNetWork");
}

- (void)shareDidLogout:(ShareLoginBase *)shareLogin
{
    NSLog(@"shareDidNotNetWork");
    
    NSString * accessToken = FBSession.activeSession.accessToken;
    
    NSLog(@"shareDidLogin:%@", accessToken);
    
    
    [[UserModel getInstance] signinFacebook:accessToken andCallback:^(NSInteger error, User *user) {
        if(error == 0) {
            
        } else {
            
        }
    }];
}

- (void)shareDidLoginErr:(ShareLoginBase *)shareLogin
{
    NSLog(@"shareDidLoginErr");
}

- (void)shareDidLoginTimeOut:(ShareLoginBase *)shareLogin
{
    NSLog(@"shareDidLoginTimeOut");
}

@end
