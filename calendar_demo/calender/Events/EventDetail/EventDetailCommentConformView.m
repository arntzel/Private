//
//  EventDetailCommentConformView.m
//  calender
//
//  Created by zyax86 on 8/25/13.
//  Copyright (c) 2013 fang xiang. All rights reserved.
//

#import "EventDetailCommentConformView.h"
#import <QuartzCore/QuartzCore.h>

@interface EventDetailCommentConformView()
@property (retain, nonatomic) IBOutlet UIImageView *sepLine;
@property (retain, nonatomic) IBOutlet UIView *containtView;

@end

@implementation EventDetailCommentConformView

- (void)dealloc
{
    self.sepLine = nil;
    self.containtView = nil;
    
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

- (void)updateUI
{
    [self.containtView.layer setCornerRadius:5.0f];
    [self.containtView.layer setBorderColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f].CGColor];
    [self.containtView.layer setBorderWidth:1.0f];
    
    [self.layer setCornerRadius:5.0f];
    [self.layer setShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.16f].CGColor];
    [self.layer setShadowRadius:3.0f];
    [self.layer setShadowOffset:CGSizeMake(0, 1.0f)];
    [self.layer setBorderColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f].CGColor];
    [self.layer setBorderWidth:1.0f];
}

+(EventDetailCommentConformView *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventDetailCommentConformView" owner:self options:nil];
    EventDetailCommentConformView * view = (EventDetailCommentConformView*)[nibView objectAtIndex:0];
    [view updateUI];
    return view;
}
@end
