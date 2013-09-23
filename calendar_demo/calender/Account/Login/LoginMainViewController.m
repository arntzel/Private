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

@interface LoginMainViewController ()<LoginMainAccessViewDelegate,LoginMainCreatViewDelegate,LoginMainSignInViewDelegate>
{
    
    UIImageView *bgView;
    UIScrollView *scrollView;
    LoginMainTitileView *titleView;
    UIButton *btnBack;
    
    LoginMainAccessView *accessView;
    LoginMainCreatView *creatView;
    LoginMainSignInView *signInView;
}

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
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
    titleView = [LoginMainTitileView creatView];
    [scrollView addSubview:titleView];
    CGRect frame = titleView.frame;
    frame.origin.y = 20;
    titleView.frame = frame;
    
    btnBack = [[UIButton alloc] initWithFrame:CGRectMake(18, 18, 21, 21)];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"event_detail_nav_back.png"] forState:UIControlStateNormal];
    [self.view addSubview:btnBack];
    
//    [self configAccessView];
//    [self configCreatView];
    [self configSignInView];
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
}

- (void)configSignInView
{
    signInView = [LoginMainSignInView creatView];
    [scrollView addSubview:signInView];
    signInView.delegate = self;
    CGRect frame = signInView.frame;
    frame.origin.y = titleView.frame.size.height + titleView.frame.origin.y + 120;
    signInView.frame = frame;
}


#pragma mark -
#pragma mark LoginMainAccessViewDelegate
- (void)btnSignUpSelected
{
    
}

- (void)btnSignInSelected
{
    
}

#pragma mark -
#pragma mark LoginMainCreatViewDelegate

- (void)btnFacebookSignUpDidClick
{
    
}

- (void)btnGoogleSignUpDidClick
{
    
}

- (void)btnSignUpDidClick
{
    
}

#pragma mark -
#pragma mark LoginMainSignInViewDelegate

- (void)btnFacebookSignInDidClick
{
    
}

- (void)btnGoogleSignInDidClick
{
    
}

- (void)btnSignInDidClick
{
    
}

- (void)btnForgotPasswordDidClick
{
    
}


@end
