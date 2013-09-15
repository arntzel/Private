//
//  EventDetailTimeView.m
//  detail
//
//  Created by zyax86 on 13-8-4.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDetailTimeView.h"
#import "EventDetailFinailzeView.h"
#import "EventDetailHeader.h"
#import "EventDetailInviteeConformView.h"
#import "EventDetailTimeLabelView.h"
#import "EventDetailHeaderListView.h"

@interface EventDetailTimeView()
{
    EventDetailTimeLabelView *timeLabelView;
    EventDetailFinailzeView *finailzeView;
    
    EventDetailHeaderListView *headerListView;

    EventDetailInviteeConformView *conformView;

}
@end

@implementation EventDetailTimeView

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addTimeLabelView];
        [self addFinailzeView];
        [self addInviteeListView];
        
        [self addConformView];
        
        [self updateUI];
    }
    return self;
}

- (void)dealloc
{    
    [timeLabelView release];
    [headerListView release];
    [finailzeView release];
    [conformView release];
    
    [super dealloc];
}



- (void)addTimeLabelView
{
    timeLabelView = [[EventDetailTimeLabelView creatView] retain];
    
    CGRect frame = timeLabelView.frame;
    frame.origin.x = 7;
    frame.origin.y = 27;
    timeLabelView.frame = frame;
    
    [self addSubview:timeLabelView];
}

- (void)addFinailzeView
{
    finailzeView = [[EventDetailFinailzeView creatView] retain];
    
    CGRect frame = finailzeView.frame;
    frame.origin.x = 7;
    frame.origin.y = timeLabelView.frame.origin.y + timeLabelView.frame.size.height + 7;
    finailzeView.frame = frame;
    
    [self addSubview:finailzeView];
}

- (void)addInviteeListView
{
    NSArray *headerArray = @[[UIImage imageNamed:@"header1.jpg"],
                             [UIImage imageNamed:@"header2.jpg"],
                             [UIImage imageNamed:@"header3.jpg"],
                             [UIImage imageNamed:@"header4.jpg"],
                             [UIImage imageNamed:@"header5.jpg"],
                             [UIImage imageNamed:@"header6.jpg"],
                             [UIImage imageNamed:@"header7.jpg"],
                             [UIImage imageNamed:@"header8.jpg"],
                             [UIImage imageNamed:@"header9.jpg"]];
    
    
    
    
    headerListView = [[EventDetailHeaderListView alloc] initWithHeaderArray:headerArray andCountLimit:8 ShowArraw:YES ShowSelectedStatu:YES];
    
    CGRect frame = headerListView.frame;
    frame.origin.x = 7;
    frame.origin.y = finailzeView.frame.origin.y + finailzeView.frame.size.height + 10;
    headerListView.frame = frame;
    
    [self addSubview:headerListView];
}

- (void)addConformView
{
    conformView = [[EventDetailInviteeConformView creatView] retain];
    
    CGRect frame = conformView.frame;
    frame.origin.x = 7;
    frame.origin.y = headerListView.frame.origin.y + headerListView.frame.size.height + 15;
    conformView.frame = frame;
    
    [self addSubview:conformView];
}

- (void)updateUI
{
    [self setBackgroundColor:[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0]];
    
    CGRect timeContentViewFrame = self.frame;
    timeContentViewFrame.size = CGSizeMake(320, conformView.frame.origin.y + conformView.frame.size.height + 20);
    self.frame = timeContentViewFrame;
}
@end
