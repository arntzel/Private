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
    frame.size.height = subViewCount*56 + 10;
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

@end
