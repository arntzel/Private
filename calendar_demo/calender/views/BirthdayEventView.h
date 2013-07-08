//
//  BirthdayEventView.h
//  calender
//
//  Created by xiangfang on 13-7-8.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

#define BirthdayEventView_Height  55

@interface BirthdayEventView : UIView

@property IBOutlet UILabel * labTitle;
@property IBOutlet UIImageView * imgUser;

/*
 Update the date in the View
 */
-(void) refreshView:(Event *) event;

/*
 Create a EventView object with default data
 */
+(BirthdayEventView *) createEventView;


@end
