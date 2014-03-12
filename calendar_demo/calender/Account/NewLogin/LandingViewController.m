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

#import "UIColor+Hex.h"
#import "LandingViewController.h"
#import "LoginViewController.h"
#import "OnboardingViewController.h"
#import "CreateNewAccountViewController.h"

@interface LandingViewController ()
{
    UIImageView *bgView;
    UIImageView *logoView;
    UIImageView *bannerView;
    UILabel *textLabel;
    UIButton *loginBtn;
    UIButton *signupBtn;
    
    LoginViewController *loginViewController;
}
@end

@implementation LandingViewController

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
    
    logoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"calvin_icon_large.png"]];
    
    int logoX = self.view.bounds.size.width/2 - LOGO_WIDTH/2;
    [logoView setFrame:CGRectMake(logoX, 80, LOGO_WIDTH, LOGO_HEIGHT)];
    [self.view addSubview:logoView];
    
    bannerView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"calvin_logo_large.png"]];
    
    int bannerX = self.view.bounds.size.width/2 - BANNER_WIDTH/2;
    [bannerView setFrame:CGRectMake(bannerX, 80 + LOGO_HEIGHT + 20, BANNER_WIDTH, BANNER_HEIGHT)];
    [self.view addSubview:bannerView];
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:22.0];
    
    textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    [textLabel setFont:font];
    [textLabel setTextColor:[UIColor generateUIColorByHexString:@"1f1e1e"]];
    [textLabel setText:@"More Plans,Less Planning."];
    [textLabel sizeToFit];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setCenter:CGPointMake(self.view.center.x, bannerView.frame.origin.y + BANNER_HEIGHT + 30)];
    [self.view addSubview:textLabel];
    
    loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(0, 0, 304, 45);
    UIColor *loginBtnBgColor = [UIColor generateUIColorByHexString:@"#d2ece8" withAlpha:0.9];
    [loginBtn setBackgroundColor:loginBtnBgColor];
    [loginBtn setTitle:@"Log In" forState:UIControlStateNormal];
    UIFont *btnFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:25.0];
    [[loginBtn titleLabel]setFont:btnFont];
    [[loginBtn titleLabel] setTextColor:[UIColor blackColor]];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [loginBtn setCenter:CGPointMake(self.view.center.x, textLabel.frame.origin.y + 140)];
    [loginBtn addTarget:self action:@selector(onLoginButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    signupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signupBtn.frame = CGRectMake(0, 0, 304, 45);
    UIColor *signupBtnBgColor = [UIColor generateUIColorByHexString:@"#18a48b" withAlpha:0.9];
    [signupBtn setBackgroundColor:signupBtnBgColor];
    [signupBtn setTitle:@"Sign up" forState:UIControlStateNormal];
    [[signupBtn titleLabel]setFont:btnFont];
    [[signupBtn titleLabel] setTextColor:[UIColor whiteColor]];
    [signupBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signupBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [signupBtn setCenter:CGPointMake(self.view.center.x, loginBtn.frame.origin.y + 75)];
    [signupBtn addTarget:self action:@selector(onSignupButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signupBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

-(void)onLoginButtonTapped
{
    if (!loginViewController) {
        loginViewController = [[LoginViewController alloc]init];
    }
    //[self presentViewController:loginViewController animated:YES completion:nil];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

-(void)onSignupButtonTapped
{
    if (!loginViewController) {
        loginViewController = [[LoginViewController alloc]init];
    }
    
//    OnboardingViewController *onboardingViewController = [[OnboardingViewController alloc]init];
//    [onboardingViewController setDelegate:loginViewController];
//    [self.navigationController pushViewController:onboardingViewController animated:YES];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showGuide"] == YES) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"showGuide"];
        OnboardingViewController *onboardingViewController = [[OnboardingViewController alloc]init];
        [onboardingViewController setDelegate:loginViewController showLastOnly:NO];
        [self.navigationController pushViewController:onboardingViewController animated:YES];
    } else {
        OnboardingViewController *onboardingViewController = [[OnboardingViewController alloc]init];
        [onboardingViewController setDelegate:loginViewController showLastOnly:YES];
        [self.navigationController pushViewController:onboardingViewController animated:YES];
    }
    
}

@end
