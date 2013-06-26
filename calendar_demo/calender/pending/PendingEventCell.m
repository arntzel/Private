//
//  PendingEventCell.m
//  calender
//
//  Created by xiangfang on 13-6-23.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "PendingEventCell.h"

@implementation PendingEventCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void) refreshView:(Event*) event
{
    
}

+(PendingEventCell*) createView {

    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"PendingEventCell" owner:self options:nil];
    PendingEventCell * view = (PendingEventCell*)[nibView objectAtIndex:0];
    return view;
    
}

@end
