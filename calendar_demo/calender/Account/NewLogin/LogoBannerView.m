//
//  LogoBannerView.m
//  Calvin
//
//  Created by Kevin Wu on 3/8/14.
//  Copyright (c) 2014 Pencil Me, Inc. All rights reserved.
//

#import "LogoBannerView.h"
#import "UIColor+Hex.h"
#import "ViewUtils.h"
@implementation LogoBannerView
{
    UIActivityIndicatorView *loadingView;
}
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) awakeFromNib
{
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    self.title.textColor = [UIColor generateUIColorByHexString:@"#1f1e1e"];
    self.gLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.gLoginBtn.frame = CGRectMake(0, 0, 304, 45);
    UIColor *loginBtnBgColor = [UIColor generateUIColorByHexString:@"#df4a32"];
    [self.gLoginBtn setBackgroundColor:loginBtnBgColor];
    [self.gLoginBtn setTitle:@"Sign up with" forState:UIControlStateNormal];
    UIFont *btnFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
    [[self.gLoginBtn titleLabel]setFont:btnFont];
    [[self.gLoginBtn titleLabel] setTextColor:[UIColor whiteColor]];
    [self.gLoginBtn setCenter:CGPointMake(self.center.x, 400)];
    CALayer *gLayer = [self getButtonSepLayer];
    [self.gLoginBtn.layer addSublayer:gLayer];
    [self.gLoginBtn setImage:[UIImage imageNamed:@"google_plus_icon.png"] forState:UIControlStateNormal];
    [self.gLoginBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -150, 0, 0)];
    [self.gLoginBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -100, 0, 0)];
    [self.gLoginBtn addTarget:self action:@selector(doSignupGoogle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.gLoginBtn];
    
    UILabel *gLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.gLoginBtn.frame.origin.x + 180, self.gLoginBtn.frame.origin.y + 10, 80, 23)];
    UIFont *btnFont2 = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0];
    [gLabel setText:@"Google"];
    [gLabel setTextColor:[UIColor whiteColor]];
    [gLabel setFont:btnFont2];
    [self addSubview:gLabel];
    
    self.otherOptionsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.otherOptionsBtn.frame = CGRectMake(10, 435, 300, 40);
    [self.otherOptionsBtn setTitle:@"Other sign up options" forState:UIControlStateNormal];
    UIFont *otherFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
    [[self.otherOptionsBtn titleLabel] setFont:otherFont];
    [self.otherOptionsBtn setBackgroundColor:[UIColor clearColor]];
    [[self.otherOptionsBtn titleLabel]setTextColor:[UIColor generateUIColorByHexString:@"#8a9593"]];
    [self.otherOptionsBtn setTitleColor:[UIColor generateUIColorByHexString:@"#8a9593"] forState:UIControlStateNormal];
    [self.otherOptionsBtn addTarget:self action:@selector(onOtherOptionTapped) forControlEvents:UIControlEventTouchUpInside];
    //[self.otherOptionsBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];

    [self addSubview:self.otherOptionsBtn];
    
    loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadingView.center = self.center;
    loadingView.hidesWhenStopped = YES;
    [self addSubview:loadingView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onLoginSuccess:) name:@"LOGINSUCCESS" object:nil];
}

-(CALayer *)getButtonSepLayer
{
    CALayer *sepLayer = [CALayer layer];
    [sepLayer setFrame:CGRectMake(45, 0, 1, 45)];
    [sepLayer setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.3].CGColor];
    return sepLayer;
}

-(void)onOtherOptionTapped
{
    if ([delegate respondsToSelector:@selector(showOtherOption)]) {
        [delegate showOtherOption];
    }
}

-(void)doSignupGoogle
{
    if ([delegate respondsToSelector:@selector(signUpGoogle)]) {
        [self.gLoginBtn setEnabled:NO];
        [self.otherOptionsBtn setEnabled:NO];
        [loadingView startAnimating];
        [delegate signUpGoogle];
    }
}

-(void)onLoginSuccess:(NSNotification *)notification
{
    [loadingView stopAnimating];
    [self.gLoginBtn setEnabled:YES];
    [self.gLoginBtn setEnabled:YES];
    
}

+(LogoBannerView *) createWithDelegate:(id<OnBoardingViewControllerDelegate>) thedelegate
{
    LogoBannerView *view =(LogoBannerView *)[ViewUtils createView:@"LogoBannerView"];
    view.delegate = thedelegate;
    return view;
}

@end
