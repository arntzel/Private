//
//  OnboardingViewController.m
//  Calvin
//
//  Created by Kevin Wu on 3/8/14.
//  Copyright (c) 2014 Pencil Me, Inc. All rights reserved.
//

#import "OnboardingViewController.h"
#import "UIColor+Hex.h"
#import "OnboardingContentView.h"
#import "LogoBannerView.h"
#import "OtherSignupOptionViewController.h"
#import "LoginViewController.h"
#import "GreenPageControl.h"

#define SCROLL_PAGES  4

@interface OnboardingViewController ()<UIScrollViewDelegate, OnBoardingViewControllerDelegate,LoginViewControllerDelegate>
{
    UIImageView *bgView;
    UIView *navView;
    UIButton *leftBtn;
    UIButton *rightBtn;
    UIPageControl *pageControl;
    UIScrollView *scrollview;
    int currentPage;
    
    OnboardingContentView *view1;
    OnboardingContentView *view2;
    OnboardingContentView *view3;
    LogoBannerView *view4;
    
    UIViewController<LoginViewControllerDelegate> *delegete;
    
    BOOL showLastPageOnly;
}

@end

@implementation OnboardingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setDelegate:(UIViewController<LoginViewControllerDelegate> *) theDelegate showLastOnly:(BOOL)flag
{
    delegete = theDelegate;
    showLastPageOnly = flag;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feed_background_image.png"]];
    [bgView setFrame:CGRectMake(0, -5, self.view.bounds.size.width, self.view.bounds.size.height +6)];
    [self.view addSubview:bgView];
    
    navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    [navView setBackgroundColor :[UIColor clearColor]];
    
    UIColor *navFontColor =[UIColor generateUIColorByHexString:@"#18a48b"];
    UIColor *dotUnselectColor =[UIColor colorWithRed:200.0/255.0 green:226.0/255.0 blue:213.0/255.0 alpha:1.0];
    [self.view addSubview:navView];
    
    currentPage = 0;
    pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(125, 25, 80, 30)];
    pageControl.currentPageIndicatorTintColor = navFontColor;
    pageControl.pageIndicatorTintColor = dotUnselectColor;
//    pageControl = [[GreenPageControl alloc]initWithFrame:CGRectMake(110, 25, 80, 30) normalImage:[UIImage imageNamed:@"ellipse_100%@2x.png"] highlightedImage:[UIImage imageNamed:@"ellipse_20%@2x.png"] dotsNumber:SCROLL_PAGES sideLength:10 dotsGap:1];
    pageControl.numberOfPages=SCROLL_PAGES;
    pageControl.currentPage=currentPage;
    //[pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
    
    if (showLastPageOnly) {
        pageControl.hidden = YES;
    }
    
    leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(14, 20, 80, 44)];
    UIFont *navBtnFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    [leftBtn setTitle:@"Back" forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(-2, -5, 0, 0)];
    [leftBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [leftBtn.titleLabel setFont:navBtnFont];
    [leftBtn setTitleColor:navFontColor forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(onBackButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    //[leftBtn setHidden:YES];
    [navView addSubview:leftBtn];
    
    rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(250, 20, 80, 44)];
    [rightBtn setTitle:@"Next" forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"next_icon.png"] forState:UIControlStateNormal];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(-2, 50, 0, 0)];
    [rightBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [rightBtn.titleLabel setFont:navBtnFont];
    [rightBtn setTitleColor:navFontColor forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(onNextButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:rightBtn];
    
    if (!showLastPageOnly) {
        scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0,70 ,self.view.frame.size.width, self.view.bounds.size.height - 70)];
        scrollview.showsVerticalScrollIndicator = NO;
        scrollview.showsHorizontalScrollIndicator = NO;
        scrollview.pagingEnabled = YES;
        scrollview.contentSize=CGSizeMake(scrollview.frame.size.width*SCROLL_PAGES, scrollview.frame.size.height);
        
        scrollview.scrollsToTop = NO;
        scrollview.delegate=self;
        scrollview.bounces= NO;
        scrollview.directionalLockEnabled = YES;
        [self initScrollContentViews];
        [self.view addSubview:scrollview];
    } else {
        view4 = [LogoBannerView createWithDelegate:self];
        [view4 setFrame:CGRectMake(0, 70, self.view.bounds.size.width, self.view.bounds.size.height - 70)];
        [self.view addSubview:view4];
        [rightBtn setHidden:YES];
        [leftBtn setHidden:NO];
    }
    
}

-(void)initScrollContentViews
{
    view1 = [OnboardingContentView create];
    [view1 setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 70)];
    view1.title.text = @"Skip the Inbox";
    view1.subTitle.text = @"Schedule Event and make plans directly from your calendar";
    UIImage *view1Img = [UIImage imageNamed:@"calendar_screen.png"];
    //[view1 setBackgroundImage:view1Img];
    [view1.contentImage setImage:view1Img];
    
    view2 = [OnboardingContentView create];
    [view2 setFrame:CGRectMake(320, 0, self.view.bounds.size.width, self.view.bounds.size.height - 70)];
    view2.title.text = @"Collaborate on Event Details";
    view2.subTitle.text = @"Find a time and location that works for everyone";
    UIImage *view2Img = [UIImage imageNamed:@"onboarding_source_final.png"];
    [view2.contentImage setImage:view2Img];
    
    view3 = [OnboardingContentView create];
    [view3 setFrame:CGRectMake(640, 0, self.view.bounds.size.width, self.view.bounds.size.height - 70)];
    view3.title.text = @"Capture event ideas for later";
    view3.subTitle.text = @"Record and save events that you want to do in the future";
    UIImage *view3Img = [UIImage imageNamed:@"pending_screen.png"];
    //[view3 setBackgroundImage:view3Img];
    [view3.contentImage setImage:view3Img];
    
    view4 = [LogoBannerView createWithDelegate:self];
    [view4 setFrame:CGRectMake(960, 0, self.view.bounds.size.width, self.view.bounds.size.height - 70)];
    
    [scrollview addSubview:view1];
    [scrollview addSubview:view2];
    [scrollview addSubview:view3];
    [scrollview addSubview:view4];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1
{
    if (!showLastPageOnly) {
        CGPoint offset=scrollView1.contentOffset;
        CGRect bounds=scrollView1.frame;
        currentPage = offset.x/bounds.size.width;
        [pageControl setCurrentPage:currentPage];
        if (currentPage == (SCROLL_PAGES - 1)) {
            [leftBtn setHidden:NO];
            [rightBtn setHidden:YES];
            [pageControl setHidden:YES];
        } else {
            if (currentPage == 0) {
                [leftBtn setHidden:NO];
                [rightBtn setHidden:NO];
            } else {
                [leftBtn setHidden:YES];
                [rightBtn setHidden:NO];
                [pageControl setHidden:NO];
            }
        }
    }
}

-(void)onNextButtonTapped
{
    currentPage++;
    if (currentPage <= SCROLL_PAGES) {
        CGSize viewsize=scrollview.frame.size;
        CGRect rect=CGRectMake(currentPage*viewsize.width, 0, viewsize.width, viewsize.height);
        [scrollview scrollRectToVisible:rect animated:YES];
        
        //CGPoint offset=scrollview.contentOffset;
        //CGRect bounds=scrollview.frame;
        [pageControl setCurrentPage:currentPage];
        if (currentPage == (SCROLL_PAGES - 1)) {
            [leftBtn setHidden:NO];
            [rightBtn setHidden:YES];
        } else {
            [leftBtn setHidden:YES];
            [rightBtn setHidden:NO];
        }
    }
}

-(void)onBackButtonTapped {
    if (!showLastPageOnly) {
        if (currentPage == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            currentPage = SCROLL_PAGES - 2;
            CGSize viewsize=scrollview.frame.size;
            CGRect rect=CGRectMake(currentPage*viewsize.width, 0, viewsize.width, viewsize.height);
            [scrollview scrollRectToVisible:rect animated:YES];
            [pageControl setCurrentPage:currentPage];
            [leftBtn setHidden:YES];
            [rightBtn setHidden:NO];
            [pageControl setHidden:NO];
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showOtherOption
{
    OtherSignupOptionViewController *other = [[OtherSignupOptionViewController alloc]init];
    [other setDelegate:delegete];
    [self.navigationController pushViewController:other animated:YES];
}

-(void)signUpGoogle
{
    if ([delegete respondsToSelector:@selector(doSignupGoogle)]) {
        [delegete doSignupGoogle];
    }
}

@end
