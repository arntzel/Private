//
//  OtherSignupOptionViewController.m
//  Calvin
//
//  Created by Kevin Wu on 3/9/14.
//  Copyright (c) 2014 Pencil Me, Inc. All rights reserved.
//

#import "OtherSignupOptionViewController.h"
#import "UIColor+Hex.h"
#import "CreateNewAccountViewController.h"
#import "LoginViewController.h"

@interface OtherSignupOptionViewController ()
{
    UIImageView *bgView;
    UIView *navView;
    UIButton *leftBtn;
    UILabel *labelTitle;
    UIButton *fbLoginBtn;
    UIButton *emailLoginBtn;
    
    id<LoginViewControllerDelegate> delegate;
    UIActivityIndicatorView *loadingView;
}
@end

@implementation OtherSignupOptionViewController

-(void)setDelegate:(id<LoginViewControllerDelegate>) theDelegate
{
    delegate = theDelegate;
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
	// Do any additional setup after loading the view.
    bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feed_background_image.png"]];
    [bgView setFrame:CGRectMake(0, -5, self.view.bounds.size.width, self.view.bounds.size.height +6)];
    [self.view addSubview:bgView];
    
    navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    [navView setBackgroundColor:[UIColor generateUIColorByHexString:@"#18a48b"]];
    
    leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(14, 20, 80, 44)];
    [leftBtn setTitle:@"Back" forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(-2, -5, 0, 0)];
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
    
    labelTitle.text = @"Other sign up options";
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    [labelTitle setTextColor:[UIColor whiteColor]];
    //[labelTitle setFont:[UIFont boldSystemFontOfSize:14]];
    [navView addSubview:labelTitle];
    [self.view addSubview:navView];
    
    UIFont *btnFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
    
    fbLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fbLoginBtn.frame = CGRectMake(0, 0, 304, 45);
    UIColor *fbBtnBgColor = [UIColor generateUIColorByHexString:@"#3a5897" withAlpha:0.9];
    [fbLoginBtn setBackgroundColor:fbBtnBgColor];
    [fbLoginBtn setTitle:@"Sign up with" forState:UIControlStateNormal];
    [[fbLoginBtn titleLabel]setFont:btnFont];
    [[fbLoginBtn titleLabel] setTextColor:[UIColor whiteColor]];
    [fbLoginBtn setCenter:CGPointMake(self.view.center.x, navView.frame.origin.y + 120)];
    CALayer *fbLayer = [self getButtonSepLayer];
    [fbLoginBtn.layer addSublayer:fbLayer];
    [fbLoginBtn setImage:[UIImage imageNamed:@"facebook_icon.png"] forState:UIControlStateNormal];
    [fbLoginBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -150, 0, 0)];
    [fbLoginBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -100, 0, 0)];
    [fbLoginBtn addTarget:self action:@selector(onLoginFBTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fbLoginBtn];
    
    UILabel *gLabel = [[UILabel alloc]initWithFrame:CGRectMake(fbLoginBtn.frame.origin.x + 173, fbLoginBtn.frame.origin.y + 10, 100, 23)];
    gLabel.textAlignment = NSTextAlignmentLeft;
    UIFont *btnFont2 = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0];
    [gLabel setText:@"Facebook"];
    [gLabel setTextColor:[UIColor whiteColor]];
    [gLabel setFont:btnFont2];
    [self.view addSubview:gLabel];
    
    emailLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    emailLoginBtn.frame = CGRectMake(0, 0, 304, 45);
    UIColor *emailBtnBgColor = [UIColor generateUIColorByHexString:@"#18a48b"];
    [emailLoginBtn setBackgroundColor:emailBtnBgColor];
    [emailLoginBtn setTitle:@"Sign up with Email" forState:UIControlStateNormal];
    [[emailLoginBtn titleLabel]setFont:btnFont];
    [[emailLoginBtn titleLabel] setTextColor:[UIColor whiteColor]];
    [emailLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [emailLoginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [emailLoginBtn setCenter:CGPointMake(self.view.center.x, fbLoginBtn.frame.origin.y + 75)];
    CALayer *emailLayer = [self getButtonSepLayer];
    [emailLoginBtn.layer addSublayer:emailLayer];
    [emailLoginBtn setImage:[UIImage imageNamed:@"email_icon.png"] forState:UIControlStateNormal];
    [emailLoginBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -100, 0, 0)];
    [emailLoginBtn addTarget:self action:@selector(onSignupWithEmailTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:emailLoginBtn];
    
    loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadingView.center = self.view.center;
    loadingView.hidesWhenStopped = YES;
    [self.view addSubview:loadingView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onLoginSuccess:) name:@"LOGINSUCCESS" object:nil];
}

-(CALayer *)getButtonSepLayer
{
    CALayer *sepLayer = [CALayer layer];
    [sepLayer setFrame:CGRectMake(45, 0, 1, 45)];
    [sepLayer setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.3].CGColor];
    return sepLayer;
}

-(void)onSignupWithEmailTapped
{
    CreateNewAccountViewController *signUp = [[CreateNewAccountViewController alloc]init];
    [signUp setDelegate:delegate];
    [self.navigationController pushViewController:signUp animated:YES];
}

-(void)onBackButtonTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onLoginSuccess:(NSNotification *)notification
{
    [loadingView stopAnimating];
    //[fbLoginBtn setEnabled:YES];
    //[emailLoginBtn setEnabled:YES];
}

-(void)onLoginFBTapped
{
    if ([delegate respondsToSelector:@selector(doSignupFacebook)]) {
        //[emailLoginBtn setEnabled:NO];
        //[fbLoginBtn setEnabled:NO];
        [loadingView startAnimating];
        [delegate doSignupFacebook];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
