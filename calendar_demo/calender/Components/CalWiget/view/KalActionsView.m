//
//  KalActionsView.m
//  Calvin
//
//  Created by Kevin Wu on 12/9/13.
//  Copyright (c) 2013 fang xiang. All rights reserved.
//

#import "KalActionsView.h"
#import "UIColor+Hex.h"

@implementation KalActionsView

-(id)initWithFrame:(CGRect)frame withDelegate:(id<KalViewDelegate>)theDelegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        delegate = theDelegate;
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
        
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
        
        UIButton *todayBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, self.frame.size.height)];
        UIColor *titleColor = [UIColor generateUIColorByHexString:@"#18a48b"];
        [todayBtn setTitleColor:titleColor forState:UIControlStateNormal];
        [todayBtn setTitle:@"TODAY" forState:UIControlStateNormal];
        todayBtn.titleLabel.font = font;
        [todayBtn addTarget:delegate action:@selector(showToday) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:todayBtn];
        
        UIButton *calendarBtn = [[UIButton alloc]initWithFrame:CGRectMake(210, 0, 100, self.frame.size.height)];
        [calendarBtn setTitleColor:titleColor forState:UIControlStateNormal];
        [calendarBtn setTitle:@"CALENDARS" forState:UIControlStateNormal];
        calendarBtn.titleLabel.font = font;
        [calendarBtn addTarget:delegate action:@selector(showCalendar) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:calendarBtn];
        
        UIView *sepLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
        //CGFloat lineColor1[4]={209.0/255.0,217.0/255.0,210.0/255.0,1.0};
        [sepLine setBackgroundColor:[UIColor colorWithRed:209.0/255.0 green:217.0/255.0 blue:210.0/255.0 alpha:0.5]];
        //UIColor *lineColor = [UIColor generateUIColorByHexString:@"#d1d9d2"];
        //[sepLine setBackgroundColor:lineColor];
        [self addSubview:sepLine];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame withDelegate:nil];
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
