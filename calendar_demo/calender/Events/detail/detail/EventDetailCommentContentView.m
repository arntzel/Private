//
//  EventDetailCommentContentView.m
//  detail
//
//  Created by zyax86 on 13-8-4.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDetailCommentContentView.h"
#import "EventDetailCommentView.h"

@interface EventDetailCommentContentView()
{
    EventDetailCommentView *commentView;
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
        [self addCommentView];
        [self updateUI];
    }
    return self;
}

- (void)dealloc
{    
    [commentView release];
    
    [super dealloc];
}

- (void)updateUI
{    
    CGRect commentContentViewFrame = self.frame;
    commentContentViewFrame.size = CGSizeMake(320, commentView.frame.size.height);
    self.frame = commentContentViewFrame;
}

- (void)addCommentView
{
    commentView = [[EventDetailCommentView creatView] retain];
    [self addSubview:commentView];
}


@end
