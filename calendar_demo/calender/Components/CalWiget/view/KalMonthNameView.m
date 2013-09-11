//
//  KalMonthNameView.m
//  calender
//
//  Created by zyax86 on 13-6-30.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "KalMonthNameView.h"

@implementation KalMonthNameView
{
    UILabel *monthNameLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f]];
//        [self setBackgroundColor:[UIColor clearColor]];
        
        monthNameLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [self addSubview:monthNameLabel];
        monthNameLabel.textColor = [UIColor colorWithRed:48.0/255.0f green:48.0/255.0f blue:48.0/255.0f alpha:1.0f];
        monthNameLabel.font = [UIFont boldSystemFontOfSize:25];
        monthNameLabel.textAlignment = NSTextAlignmentCenter;
        [monthNameLabel setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [monthNameLabel setFrame:self.bounds];
}

- (void)setMonthNameAtIndex:(NSInteger)index
{
    NSArray *monthNameArray = [NSArray arrayWithObjects:
        @"january",
        @"february",
        @"march",
        @"april",
        
        @"may",
        @"june",
        @"july",
        @"august",
        
        @"september",
        @"october",
        @"november",
        @"december",
        nil
    ];
    NSString *monthName = [monthNameArray objectAtIndex:index - 1];
    monthNameLabel.text = [monthName uppercaseString];
}

- (void)dealloc
{
    [monthNameLabel release];
    
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
