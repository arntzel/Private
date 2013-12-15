//
//  EventDetailCommentConformed.m
//  calender
//
//  Created by zyax86 on 8/25/13.
//  Copyright (c) 2013 fang xiang. All rights reserved.
//

#import "EventDetailCommentConformedView.h"

@implementation EventDetailCommentConformedView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setConformTimeString:(NSString *)conformTime
{
    self.labConformTime.text = conformTime;
}

+(EventDetailCommentConformedView *)creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventDetailCommentConformedView" owner:self options:nil];
    EventDetailCommentConformedView * view = (EventDetailCommentConformedView*)[nibView objectAtIndex:0];
    return view;
}

@end
