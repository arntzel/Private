//
//  EventDetailCommentConformView.m
//  calender
//
//  Created by zyax86 on 8/25/13.
//  Copyright (c) 2013 fang xiang. All rights reserved.
//

#import "EventDetailCommentConformView.h"
#import <QuartzCore/QuartzCore.h>



@implementation EventDetailCommentConformView
{
    UIView * containtView;
}

- (void)dealloc
{
    [containtView release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void) updateUI:(BOOL) isCreator andInviteeCanProposeTime:(BOOL) can
{
    for (UIView * subView in [self subviews]) {
        [subView removeFromSuperview];
    }

    containtView = [[UIView alloc] initWithFrame:CGRectMake(7, 10, 304, 50)];
    containtView.backgroundColor = [UIColor whiteColor];
    [self addSubview:containtView];

    [containtView.layer setCornerRadius:5.0f];
    [containtView.layer setShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.16f].CGColor];
    [containtView.layer setShadowRadius:3.0f];
    [containtView.layer setShadowOffset:CGSizeMake(0, 1.0f)];
    [containtView.layer setBorderColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f].CGColor];
    [containtView.layer setBorderWidth:1.0f];

    
       
    if(isCreator) {
        UIButton * btn = [self createButton:@"Add New Time" andY:0];
        [containtView addSubview:btn];

        [btn addTarget:self action:@selector(addNewTime:) forControlEvents:UIControlEventTouchUpInside];
        
    } else {

        if(can) {

            int y = 0;

            UIButton * btn = [self createButton:@"Propose New Time" andY:y];
            [containtView addSubview:btn];

            y += btn.frame.size.height;

            UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, 304, 1)];
            line.image = [UIImage imageNamed:@"event_detail_comment_conform_line.png"];
            [containtView addSubview:line];
            [line release];

            y += line.frame.size.height;

            UIButton * btn2 = [self createButton:@"Decline Event" andY:y];
            [containtView addSubview:btn2];

            [btn addTarget:self action:@selector(proposeNewTime:) forControlEvents:UIControlEventTouchUpInside];
            [btn2 addTarget:self action:@selector(declineEvent:) forControlEvents:UIControlEventTouchUpInside];

        } else {
            UIButton * btn = [self createButton:@"Decline Event" andY:0];
            [containtView addSubview:btn];

            [btn addTarget:self action:@selector(addNewTime:) forControlEvents:UIControlEventTouchUpInside];
        }
    }

     [self layOutSubViews];
}

- (void)layOutSubViews
{
    CGFloat offsetY = 0;

    for(UIView * subView in [containtView subviews]) {
        CGRect frame = subView.frame;
        frame.origin = CGPointMake(0, offsetY);
        subView.frame = frame;
        offsetY += frame.size.height;
    }

    
    CGRect frame = containtView.frame;
    frame.size.height = offsetY;
    containtView.frame = frame;

    offsetY += 30;
    frame = self.frame;
    frame.size.height = offsetY;
    self.frame = frame;
}


-(UIButton *) createButton:(NSString *) title andY:(int) y
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, y, 304, 45);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    return btn;
}


-(void) addNewTime:(id)sender
{
    if(self.delegate != nil) {
        [self.delegate onAddNewTime];
    }
}

-(void) proposeNewTime:(id)sender
{
    if(self.delegate != nil) {
        [self.delegate onProposeNewTime];
    }

}

-(void) declineEvent:(id)sender
{
    if(self.delegate != nil) {
        [self.delegate onDeclineTime];
    }
}

@end
