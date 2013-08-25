//
//  EventDetailCommentContentView.m
//  detail
//
//  Created by zyax86 on 13-8-4.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDetailCommentContentView.h"

#import "EventDetailCommentView.h"
#import "EventDetailCommentTextView.h"
#import "EventDetailCommentConformedView.h"

@interface EventDetailCommentContentView()
{
    EventDetailCommentView *commentView;
    EventDetailCommentTextView *commentTextView;
    EventDetailCommentConformedView *conformedView;
}
@end

@implementation EventDetailCommentContentView

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addTextView];
        [self addCommentView];
        [self addConformedView];
        [self updateUI];
    }
    return self;
}

- (void)dealloc
{    
    [commentView release];
    [commentTextView release];
    [conformedView release];
    
    [super dealloc];
}

- (void)updateUI
{    
    CGRect commentContentViewFrame = self.frame;
    commentContentViewFrame.size = CGSizeMake(320, conformedView.frame.size.height + conformedView.frame.origin.y);
    self.frame = commentContentViewFrame;
}

- (void)addTextView
{
    commentTextView = [[EventDetailCommentTextView creatView] retain];
    [commentTextView setHeaderPhoto:[UIImage imageNamed:@"header10.jpg"]];
    [self addSubview:commentTextView];
}

- (void)addCommentView
{
    commentView = [[EventDetailCommentView creatView] retain];
    [commentView setHeaderPhoto:[UIImage imageNamed:@"header10.jpg"]];
    
    CGRect commentViewFrame = commentView.frame;
    commentViewFrame.origin = CGPointMake(0, commentTextView.frame.size.height);
    commentView.frame = commentViewFrame;
    
    [self addSubview:commentView];
}

- (void)addConformedView
{
    conformedView = [[EventDetailCommentConformedView creatView] retain];
    
    CGRect viewFrame = conformedView.frame;
    viewFrame.origin = CGPointMake(0, commentView.frame.size.height + commentView.frame.origin.y);
    conformedView.frame = viewFrame;
    
    [self addSubview:conformedView];
}


@end
