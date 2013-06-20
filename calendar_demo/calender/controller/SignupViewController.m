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

@interface SignupViewController ()

@end

@implementation SignupViewController

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
    
    [view.signupEmail addTarget:self action:@selector(signupEmail) forControlEvents:UIControlEventTouchUpInside];

    view.loginnow.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(login)];
    [view.loginnow addGestureRecognizer:tapGes];
                                                                                                          
    
    CGRect frame2 = view.frame;
    frame2.origin.y  = (frame.size.height - frame2.size.height)/2;
    view.frame = frame2;
    
    [self.view addSubview: view ];

}

-(void)login {

    LoginNowController * ctrl = [[LoginNowController alloc] initWithNibName:@"LoginNowController" bundle:nil];
    [self.navigationController pushViewController:ctrl animated:YES];

}

-(void) signupEmail {
    
    [self finish];

    [[UserModel getInstance] login:@"zhiwehu@gmail.com" withPassword:@"huzhiwei" andCallback:^(NSInteger error, User *user) {

        if(error == 0) {
            menuNavigation *leftController = [[menuNavigation alloc] init];
            FeedViewController * fdController = [[FeedViewController alloc] init];


            DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:fdController];
            rootController.leftViewController = leftController;

            fdController.delegate = rootController;

            [[RootNavContrller defaultInstance] popViewControllerAnimated:NO];
            [[RootNavContrller defaultInstance] pushViewController:rootController animated:YES];
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

@end
