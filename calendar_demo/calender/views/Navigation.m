//
//  Navigation.m
//  calender
//
//  Created by xiangfang on 13-5-11.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "Navigation.h"
#import <QuartzCore/QuartzCore.h>

@implementation Navigation

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(Navigation *) createNavigationView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"Navigation" owner:self options:nil];
    Navigation * view = (Navigation*)[nibView objectAtIndex:0];
    view.frame = CGRectMake(0, 0, 320, 44);

    view.unreadCount.hidden = YES;

    view.unreadCount.layer.cornerRadius = 4;//设置那个圆角的有多圆
    view.unreadCount.layer.masksToBounds = YES;//设为NO去试试

    return view;
}

@end
