//
//  AddEventPlaceView.m
//  calender
//
//  Created by fang xiang on 13-7-11.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "AddEventPlaceView.h"

@implementation AddEventPlaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)dealloc
{
    self.label = nil;
    self.btnPick = nil;
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
