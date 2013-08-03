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
#import "EventDetailFinailzeView.h"
#import "EventDetailHeader.h"
#import "EventDetailInviteeConformView.h"
#import "EventDetailInviteeView.h"
#import "EventDetailPlaceView.h"
#import "EventDetailTimeLabelView.h"
#import "EventDetailCommentView.h"



@interface ViewController ()
{
    EventDetailNavigationBar *navBar;
    EventDetailPhotoView *photoView;
    EventDetailInviteeView *inviteeView;
    EventDetailPlaceView *placeView;
    EventDetailTimeLabelView *timeLabelView;
    EventDetailFinailzeView *finailzeView;
    EventDetailInviteeConformView *conformView;
    EventDetailCommentView *commentView;
    
    UIView *timeContentView;
    UIView *commentContentView;
}
@end

@implementation ViewController

- (void)dealloc
{
    [navBar release];
    [photoView release];
    [inviteeView release];
    [placeView release];
    [timeLabelView release];
    [finailzeView release];
    [conformView release];
    [commentView release];
    
    [timeContentView release];
    [commentContentView release];
 
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.view setBackgroundColor:[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1.0]];
    [self addPhotoView];
    [self addNavBar];
    [self addInviteeView];
    [self addPlaceView];
    
    timeContentView = [[UIView alloc] initWithFrame:CGRectZero];
    [timeContentView setBackgroundColor:[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0]];
    [self.view addSubview:timeContentView];
    [self addTimeLabelView];
    [self addFinailzeView];
    [self addConformView];
    
    commentContentView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:commentContentView];
    [self addCommentView];
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

- (void)addInviteeView
{
    inviteeView = [[EventDetailInviteeView creatView] retain];
    
    CGRect frame = inviteeView.frame;
    frame.origin.x = 5;
    frame.origin.y = photoView.frame.origin.y + photoView.frame.size.height + 8;
    inviteeView.frame = frame;
    
    [self.view addSubview:inviteeView];
}

- (void)addPlaceView
{
    placeView = [[EventDetailPlaceView creatView] retain];
    
    CGRect frame = placeView.frame;
    frame.origin.x = 5 * 2 + inviteeView.frame.size.width;
    frame.origin.y = photoView.frame.origin.y + photoView.frame.size.height + 8;
    placeView.frame = frame;
        
    [self.view addSubview:placeView];
}

- (void)addTimeLabelView
{
    timeLabelView = [[EventDetailTimeLabelView creatView] retain];
    
    CGRect frame = timeLabelView.frame;
    frame.origin.x = 7;
    frame.origin.y = 27;
    timeLabelView.frame = frame;
    
    [timeContentView addSubview:timeLabelView];
}

- (void)addFinailzeView
{
    finailzeView = [[EventDetailFinailzeView creatView] retain];
    
    CGRect frame = finailzeView.frame;
    frame.origin.x = 7;
    frame.origin.y = timeLabelView.frame.origin.y + timeLabelView.frame.size.height + 7;
    finailzeView.frame = frame;

    [timeContentView addSubview:finailzeView];
}

- (void)addConformView
{
    conformView = [[EventDetailInviteeConformView creatView] retain];
    
    CGRect frame = conformView.frame;
    frame.origin.x = 7;
    frame.origin.y = finailzeView.frame.origin.y + finailzeView.frame.size.height + 40;
    conformView.frame = frame;
    
    [timeContentView addSubview:conformView];
    
    CGRect timeContentViewFrame = timeContentView.frame;
    timeContentViewFrame.origin = CGPointMake(0, placeView.frame.origin.y + placeView.frame.size.height + 14);
    timeContentViewFrame.size = CGSizeMake(320, conformView.frame.origin.y + conformView.frame.size.height + 20);
    timeContentView.frame = timeContentViewFrame;
}

- (void)addCommentView
{
    commentView = [[EventDetailCommentView creatView] retain];
    
    CGRect timeContentViewFrame = commentContentView.frame;
    timeContentViewFrame.origin = CGPointMake(0, timeContentView.frame.origin.y + timeContentView.frame.size.height);
    timeContentViewFrame.size = CGSizeMake(320, commentView.frame.origin.y + commentView.frame.size.height + 20);
    commentContentView.frame = timeContentViewFrame;
    
    [commentContentView addSubview:commentView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
