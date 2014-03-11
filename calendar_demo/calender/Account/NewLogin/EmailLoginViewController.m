//
//  EmailLoginViewController.m
//  Calvin
//
//  Created by Kevin Wu on 3/9/14.
//  Copyright (c) 2014 Pencil Me, Inc. All rights reserved.
//

#import "EmailLoginViewController.h"
#import "UIColor+Hex.h"
#import "LoginViewController.h"

@interface EmailLoginViewController ()
{
    UIImageView *bgView;
    UIView *navView;
    UIButton *leftBtn;
    UILabel *labelTitle;
    UIView *textFieldView;
    UITextField *username;
    UITextField *password;
    UIButton *loginBtn;
    UIButton *forgotPwBtn;
    
    id<LoginViewControllerDelegate>delegate;
    UIActivityIndicatorView *loadingView;
}

@end

@implementation EmailLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setDelegate:(id<LoginViewControllerDelegate>) theDelegate
{
    delegate = theDelegate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feed_background_image.png"]];
    [bgView setFrame:CGRectMake(0, -5, self.view.bounds.size.width, self.view.bounds.size.height +6)];
    [self.view addSubview:bgView];
    
    navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 70)];
    [navView setBackgroundColor:[UIColor generateUIColorByHexString:@"#18a48b"]];
    
    leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 20, 80, 44)];
    [leftBtn setTitle:@"Back" forState:UIControlStateNormal];
    [leftBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(onBackButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:leftBtn];
    
    labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    [labelTitle setBackgroundColor:[UIColor clearColor]];
    
    labelTitle.textAlignment = NSTextAlignmentCenter;
    
    labelTitle.lineBreakMode = NSLineBreakByWordWrapping;
    labelTitle.numberOfLines = 0;
    
    labelTitle.text = @"Log in with Email";
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    [labelTitle setTextColor:[UIColor whiteColor]];
    //[labelTitle setFont:[UIFont boldSystemFontOfSize:14]];
    [navView addSubview:labelTitle];
    [self.view addSubview:navView];
    
    UIColor *textBgColor = [UIColor colorWithRed:232.0/255.0 green:243.0/255.0 blue:237.0/255.0 alpha:1.0];
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0];
    username = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width - 20, 60)];
    [username setBorderStyle:UITextBorderStyleNone];
    [username setBackgroundColor:[UIColor clearColor]];
    username.placeholder = @"Email Address";
    username.autocorrectionType = UITextAutocorrectionTypeNo;
    username.autocapitalizationType = UITextAutocapitalizationTypeNone;
    username.returnKeyType = UIReturnKeyNext;
    [username setFont:font];
    
    password = [[UITextField alloc]initWithFrame:CGRectMake(10, username.frame.origin.y + 61, self.view.bounds.size.width - 20, 60)];
    [password setBorderStyle:UITextBorderStyleNone];
    [password setBackgroundColor:[UIColor clearColor]];
    password.secureTextEntry = YES;
    password.placeholder = @"Password";
    password.autocorrectionType = UITextAutocorrectionTypeNo;
    password.autocapitalizationType = UITextAutocapitalizationTypeNone;
    password.returnKeyType = UIReturnKeyDone;
    [password setFont:font];
    
    textFieldView = [[UIView alloc]initWithFrame:CGRectMake(0, navView.frame.origin.y + 120, self.view.bounds.size.width, 120)];
    [textFieldView setBackgroundColor:textBgColor];
    [textFieldView addSubview:username];
    [textFieldView addSubview:password];
    
    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, username.frame.origin.y + 60, self.view.bounds.size.width, 1)];
    [sep setBackgroundColor:[UIColor colorWithRed:207.0/255.0 green:217.0/255.0 blue:211.0/255.0 alpha:1.0]];
    
    [textFieldView addSubview:sep];
    
    [self.view addSubview:textFieldView];
    
    loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, textFieldView.frame.origin.y + 120, self.view.bounds.size.width, 45)];
    UIColor *loginBtnBgColor = [UIColor generateUIColorByHexString:@"#18a48b" withAlpha:0.9];
    [loginBtn setBackgroundColor:loginBtnBgColor];
    [loginBtn setTitle:@"Login" forState:UIControlStateNormal];
    UIFont *btnFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0];
    [[loginBtn titleLabel]setFont:btnFont];
    [[loginBtn titleLabel] setTextColor:[UIColor whiteColor]];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(onEmailLoginBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    forgotPwBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgotPwBtn.frame = CGRectMake(10, loginBtn.frame.origin.y + 45 + 20, 300, 40);
    [forgotPwBtn setTitle:@"Forgot Password" forState:UIControlStateNormal];
    UIFont *forgotFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
    [[forgotPwBtn titleLabel] setFont:forgotFont];
    [forgotPwBtn setBackgroundColor:[UIColor clearColor]];
    [[forgotPwBtn titleLabel]setTextColor:[UIColor generateUIColorByHexString:@"#8a9593"]];
    [forgotPwBtn setTitleColor:[UIColor generateUIColorByHexString:@"#8a9593"] forState:UIControlStateNormal];
    [forgotPwBtn addTarget:self action:@selector(onForgotPwBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgotPwBtn];
    
    loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadingView.center = self.view.center;
    loadingView.hidesWhenStopped = YES;
    [self.view addSubview:loadingView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onLoginSuccess:) name:@"LOGINSUCCESS" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onForgotPwBtnTapped
{
    if ([delegate respondsToSelector:@selector(doFogotPassword)]) {
        [delegate doFogotPassword];
    }
}

-(void)onEmailLoginBtnTapped
{
    NSString *name = username.text;
    NSString *pw = password.text;
    [loadingView startAnimating];
    [loginBtn setEnabled:NO];
    if ([delegate respondsToSelector:@selector(doLoginWithEmail:password:)]) {
        [delegate doLoginWithEmail:name password:pw];
    }
}

-(void)onBackButtonTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onLoginSuccess:(NSNotification *) notification
{
    //[self.view setUserInteractionEnabled:YES];
    [loadingView stopAnimating];
    [loginBtn setEnabled:YES];
}

@end
