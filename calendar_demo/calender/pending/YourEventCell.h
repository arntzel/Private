//
//  YourEventCell.h
//  calender
//
//  Created by xiangfang on 13-6-23.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface YourEventCell : UIView

@property IBOutlet UIImageView * imgView;
@property IBOutlet UILabel * labelTitle;
@property IBOutlet UILabel * labelAttendees;
@property IBOutlet UILabel * lableFinalTime;


-(void) refreshView:(Event*) event;


+(YourEventCell *) createView;

@end
