//
//  EventDetailRoundDateView.h
//  Calvin
//
//  Created by Kevin Wu on 12/23/13.
//  Copyright (c) 2013 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailRoundDateView : UIView
{
    NSDate *date;
}

@property (nonatomic, retain)NSDate *date;

- (id)initWithFrame:(CGRect)frame withDate:(NSDate *)startDate;

@end
