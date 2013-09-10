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
    //EventDetailCommentView *commentView;
    EventDetailCommentTextView *commentTextView;
    //EventDetailCommentConformedView *conformedView;
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
        //[self addTextView];
        //[self addCommentView];
        //[self addConformedView];
        //[self updateUI];
    }
    return self;
}


-(void) updateView:(User *) me andComments:(NSArray *) comments
{
    for(UIView * subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    [self addTextView:me];
    
    if(comments != nil && comments.count > 0) {
        for(Comment * cmt in comments) {
            [self addComment:cmt];
        }
    }
    
    [self updateFrame];
}

-(void) addComment:(Comment *) comment
{
    if(comment.commentor == nil) {
        [self addConformedView:comment];
    } else {
        [self addCommentView:comment];
    }
}

-(void) updateFrame
{
    CGRect frame = self.frame;
    int subViewCount = self.subviews.count;
    frame.size.height = subViewCount*56;
    self.frame = frame;
    
    for(int i=0;i<subViewCount;i++) {
        UIView * subView = [self.subviews objectAtIndex:i];
        frame = subView.frame;
        frame.origin.y = i*56;
        subView.frame = frame;
    }
}

- (void)dealloc
{    
    //[commentView release];
    [commentTextView release];
    //[conformedView release];
    
    [super dealloc];
}

//- (void)updateUI
//{    
//    CGRect commentContentViewFrame = self.frame;
//    commentContentViewFrame.size = CGSizeMake(320, conformedView.frame.size.height + conformedView.frame.origin.y);
//    self.frame = commentContentViewFrame;
//}

- (void)addTextView:(User *) user
{
    commentTextView = [[EventDetailCommentTextView creatView] retain];
    //[commentTextView setHeaderPhoto:[UIImage imageNamed:@"header10.jpg"]];
    [commentTextView setHeaderPhotoUrl:user.avatar_url];
    [self addSubview:commentTextView];
}

- (void)addCommentView :(Comment *) cmt
{
    EventDetailCommentView * commentView = [EventDetailCommentView creatView];
    //[commentView setHeaderPhoto:[UIImage imageNamed:@"header10.jpg"]];
    [commentView setHeaderPhotoUrl: cmt.commentor.avatar_url];
    

    [self insertSubview:commentView belowSubview:commentTextView];
}

- (void)addConformedView:(Comment *) cmt
{
    EventDetailCommentConformedView * conformedView = [EventDetailCommentConformedView creatView];
    
    [self insertSubview:conformedView atIndex:1];
}


@end
