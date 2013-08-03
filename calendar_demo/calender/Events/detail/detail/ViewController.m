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
 
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    [self addNavBar];
//    [self addPhotoView];
//    [self addInviteeView];
//    [self addPlaceView];
//    [self addTimeLabelView];
//    [self addFinailzeView];
//    [self addConformView];
//    [self addCommentView];
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
    [self.view addSubview:inviteeView];
}

- (void)addPlaceView
{
    placeView = [[EventDetailPlaceView creatView] retain];
    [self.view addSubview:placeView];
}

- (void)addTimeLabelView
{
    timeLabelView = [[EventDetailTimeLabelView creatView] retain];
    [self.view addSubview:timeLabelView];
}

- (void)addFinailzeView
{
    finailzeView = [[EventDetailFinailzeView creatView] retain];
    [self.view addSubview:finailzeView];
}

- (void)addConformView
{
    conformView = [[EventDetailInviteeConformView creatView] retain];
    [self.view addSubview:conformView];
}

- (void)addCommentView
{
    commentView = [[EventDetailCommentView creatView] retain];
    [self.view addSubview:commentView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
