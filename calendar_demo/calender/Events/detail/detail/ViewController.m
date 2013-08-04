//
//  ViewController.m
//  detail
//
//  Created by zyax86 on 13-7-27.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "ViewController.h"

#import "EventDetailNavigationBar.h"
#import "EventDetailPhotoView.h"

#import "EventDetailInviteePlaceView.h"
#import "EventDetailTimeView.h"
#import "EventDetailCommentContentView.h"

#import "DKLiveBlurView.h"

@interface ViewController ()
{
    EventDetailNavigationBar *navBar;
    EventDetailPhotoView *photoView;
    
    EventDetailInviteePlaceView *invitePlaceContentView;
    EventDetailTimeView *timeContentView;
    EventDetailCommentContentView *commentContentView;
    UIScrollView *scrollView;
}
@end

@implementation ViewController

- (void)dealloc
{
    [navBar release];
    [photoView release];
    
    [invitePlaceContentView release];
    [timeContentView release];    
    [commentContentView release];
    [scrollView release];
 
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.view setBackgroundColor:[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1.0]];
    [self addPhotoView];
    [self addNavBar];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navBar.frame.size.height, 320, 524)];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [scrollView setBounces:NO];
    [self.view addSubview:scrollView];

    invitePlaceContentView = [[EventDetailInviteePlaceView alloc] init];
    [scrollView addSubview:invitePlaceContentView];
    
    timeContentView = [[EventDetailTimeView alloc] init];
    [scrollView addSubview:timeContentView];

    commentContentView = [[EventDetailCommentContentView alloc] init];
    [scrollView addSubview:commentContentView];
    
    [self layOutSubViews];
    
    DKLiveBlurView *blurView= (DKLiveBlurView *)photoView.photoView;
    [blurView setOriginalImage:[UIImage imageNamed:@"2.png"]];
    //    blurView.image = [UIImage imageNamed:@"2.png"];
    blurView.scrollView = scrollView;
    blurView.isGlassEffectOn = YES;
}

- (void)addNavBar
{
    navBar = [[EventDetailNavigationBar creatView] retain];
    [self.view addSubview:navBar];
}

- (void)addPhotoView
{
    photoView = [[EventDetailPhotoView creatView] retain];
    [self.view addSubview:photoView];
}

- (void)layOutSubViews
{
    CGFloat offsetY = photoView.frame.size.height - navBar.frame.size.height;
    
    CGRect placeViewFrame = invitePlaceContentView.frame;
    placeViewFrame.origin = CGPointMake(0, offsetY);
    invitePlaceContentView.frame = placeViewFrame;
    
    CGRect timeContentViewFrame = timeContentView.frame;
    timeContentViewFrame.origin = CGPointMake(0, invitePlaceContentView.frame.size.height + invitePlaceContentView.frame.origin.y);
    timeContentView.frame = timeContentViewFrame;
    
    CGRect commentContentViewFrame = commentContentView.frame;
    commentContentViewFrame.origin = CGPointMake(0, timeContentView.frame.origin.y +  timeContentView.frame.size.height);
    commentContentView.frame = commentContentViewFrame;
    
    [scrollView setContentSize:CGSizeMake(320, 1000)];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
