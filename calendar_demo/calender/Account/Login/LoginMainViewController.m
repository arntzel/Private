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

@interface LoginMainViewController ()
{
    UIImageView *bgView;
    UIScrollView *scrollView;
    LoginMainTitileView *titleView;
    
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
    frame.origin.y = 40;
    titleView.frame = frame;
    
    [self configAccessView];
    [self configCreatView];
    [self configSignInView];
}

- (void)configAccessView
{
    accessView = [LoginMainAccessView creatView];
    [scrollView addSubview:accessView];
    CGRect frame = accessView.frame;
    frame.origin.y = self.view.bounds.size.height - frame.size.height - 40;
    accessView.frame = frame;
}

- (void)configCreatView
{
    creatView = [LoginMainCreatView creatView];
    [scrollView addSubview:creatView];
    CGRect frame = creatView.frame;
    frame.origin.y = self.view.bounds.size.height - frame.size.height - 40;
    creatView.frame = frame;
}

- (void)configSignInView
{
    signInView = [LoginMainSignInView creatView];
    [scrollView addSubview:signInView];
    CGRect frame = accessView.frame;
    frame.origin.y = self.view.bounds.size.height - frame.size.height - 40;
    signInView.frame = frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
