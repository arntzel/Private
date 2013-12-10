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

-(id) init {
    
    self = [super initWithFrame:CGRectZero];
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.frame = CGRectMake(0, 0, 320, 45.7);
    
    UIButton *todayBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, self.frame.size.height)];
    //[todayBtn setTitleColor:[UIColor colorWithRed:24.0 green:164.0 blue:0.0 alpha:1.0 forState:UIControlStateNormal]];
    UIColor *titleColor = [UIColor generateUIColorByHexString:@"#18a48b"];
    [todayBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [todayBtn setTitle:@"Today" forState:UIControlStateNormal];
    [self addSubview:todayBtn];
    
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
        UIButton *todayBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, self.frame.size.height)];
        UIColor *titleColor = [UIColor generateUIColorByHexString:@"#18a48b"];
        [todayBtn setTitleColor:titleColor forState:UIControlStateNormal];
        [todayBtn setTitle:@"Today" forState:UIControlStateNormal];
        [self addSubview:todayBtn];
    }
    return self;
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
