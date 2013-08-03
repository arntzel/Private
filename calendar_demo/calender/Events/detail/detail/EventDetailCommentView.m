//
//  EventDetailCommentView.m
//  detail
//
//  Created by zyax86 on 13-8-3.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDetailCommentView.h"

@implementation EventDetailCommentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



+(EventDetailCommentView *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventDetailCommentView" owner:self options:nil];
    EventDetailCommentView * view = (EventDetailCommentView*)[nibView objectAtIndex:0];
    
    return view;
}

@end
