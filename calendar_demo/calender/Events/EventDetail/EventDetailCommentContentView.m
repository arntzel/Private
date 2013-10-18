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

#import "Model.h"
#import "UserModel.h"
#import "Utils.h"

@interface EventDetailCommentContentView()
{
    EventDetailCommentTextView *commentTextView;
    BOOL _declined;
}
@end

#define DETAIL_COMMENT_CELL_HEIGHT 56

@implementation EventDetailCommentContentView

- (id)init
{
    return [self initWithFrame:CGRectZero];
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
    frame.size.height = subViewCount * DETAIL_COMMENT_CELL_HEIGHT;
    self.frame = frame;
    
    for(int i=0;i<subViewCount;i++) {
        UIView * subView = [self.subviews objectAtIndex:i];
        
        if(subView.hidden == YES)
            continue;
        
        frame = subView.frame;
        frame.origin.y = i* DETAIL_COMMENT_CELL_HEIGHT;
        subView.frame = frame;
    }
}

- (void)dealloc
{    
    [commentTextView release];
    
    [super dealloc];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [commentTextView hideKeyboard];
}

- (void)addTextView:(User *) user
{
    commentTextView = [[EventDetailCommentTextView creatView] retain];
    //[commentTextView setHeaderPhoto:[UIImage imageNamed:@"header10.jpg"]];
    [commentTextView setHeaderPhotoUrl:user.avatar_url];
    [self addSubview:commentTextView];
    
    [commentTextView.messageField addTarget:self action:@selector(keySend) forControlEvents:UIControlEventEditingDidEnd];
    
    if(_declined) {
        commentTextView.hidden = YES;
    } else {
        commentTextView.hidden = NO;
    }
}

-(void) keySend
{
//    [commentTextView hideKeyboard];
    
    NSString * msg = [commentTextView.messageField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(msg.length > 0) {
        Comment * cmt = [[Comment alloc] init];
        cmt.commentor = [[UserModel getInstance] getLoginUser];
        cmt.createTime = [NSDate date];
        cmt.msg = msg;
        cmt.eventID = self.eventID;
        [commentTextView showSending:YES];
        
        [[Model getInstance] createComment:cmt andCallback:^(NSInteger error, Comment *comment) {
            
            [commentTextView showSending:NO];
            
            if(error ==0) {
    
                commentTextView.messageField.text = @"";
                
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.2];
                
                [self addComment:comment];
                [cmt release];
                
                [self updateFrame];
                
                [self.delegate onEventDetailCommentContentViewFrameChanged];
                
                [UIView commitAnimations];
            } else {
                //TODO::
            }
        }];
    }    
}

- (void)addCommentView :(Comment *) cmt
{
    EventDetailCommentView * commentView = [EventDetailCommentView creatView];
    //[commentView setHeaderPhoto:[UIImage imageNamed:@"header10.jpg"]];
    [commentView updateView:cmt];

    [self insertSubview:commentView atIndex:1];
}

- (void)addConformedView:(Comment *) cmt
{
    EventDetailCommentConformedView * conformedView = [EventDetailCommentConformedView creatView];
    conformedView.labMsg.text = cmt.msg;
    conformedView.labConformTime.text = [Utils getTimeText:cmt.createTime];
    [self insertSubview:conformedView atIndex:1];
}


-(void) beginLoadComments
{

    self.frame = CGRectMake(0, 0, 320, 40);
    
    UIActivityIndicatorView * indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicatorView startAnimating];
    indicatorView.center = self.center;
    [self addSubview:indicatorView];
    [indicatorView release];

    
    if(self.delegate != nil) {
        [self.delegate onEventDetailCommentContentViewFrameChanged];
    }

    [[Model getInstance] getEventComment:self.eventID andCallback:^(NSInteger error, NSArray *comments) {

        if(error == 0) {
            self.loaded = YES;
            User * me = [[UserModel getInstance] getLoginUser];
            [self updateView:me andComments:comments];

            if(self.delegate != nil) {
                [self.delegate onEventDetailCommentContentViewFrameChanged];
            }
        } else {
            //TODO::
        }
    }];

}

-(void) setDecliend:(BOOL) declined
{
    _declined = declined;
    if(declined) {
        commentTextView.hidden = YES;
    } else {
        commentTextView.hidden = NO;
    }
    
    [self updateFrame];
}
@end
