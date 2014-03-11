//
//  CreateNewAccountViewController.m
//  Calvin
//
//  Created by Kevin Wu on 3/9/14.
//  Copyright (c) 2014 Pencil Me, Inc. All rights reserved.
//

#import "CreateNewAccountViewController.h"
#import "UIColor+Hex.h"
#import "NewAccountView.h"

@interface CreateNewAccountViewController ()
{
    UIImageView *bgView;
    UIView *navView;
    UIButton *leftBtn;
    UILabel *labelTitle;
    NewAccountView *detailView;
    
    UIButton *signUpBtn;
    
}
@end

@implementation CreateNewAccountViewController

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
    
    labelTitle.text = @"Create new account";
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    [labelTitle setTextColor:[UIColor whiteColor]];
    //[labelTitle setFont:[UIFont boldSystemFontOfSize:14]];
    [navView addSubview:labelTitle];
    [self.view addSubview:navView];
    
    detailView = [NewAccountView create];
    detailView.frame = CGRectMake(0, 70, self.view.bounds.size.width, self.view.bounds.size.height - 70);
    [self.view addSubview:detailView];
    
    UIColor *loginBtnBgColor = [UIColor generateUIColorByHexString:@"#18a48b" withAlpha:0.9];
    CGRect btnFrame = CGRectZero;
    CGFloat y = self.view.bounds.size.height;
    btnFrame.origin.x = 0;
    btnFrame.origin.y = y - 55;
    btnFrame.size.height = 55;
    btnFrame.size.width = 320;
    signUpBtn = [[UIButton alloc]initWithFrame:btnFrame];
    [signUpBtn setBackgroundColor:loginBtnBgColor];
    [signUpBtn setTitle:@"Create Account" forState:UIControlStateNormal];
    UIFont *btnFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0];
    [[signUpBtn titleLabel]setFont:btnFont];
    [[signUpBtn titleLabel] setTextColor:[UIColor whiteColor]];
    [signUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signUpBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [signUpBtn addTarget:self action:@selector(onSignupBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:signUpBtn];
}

-(void)onBackButtonTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onSignupBtnTapped
{
    
}

@end
