//
//  BirthdayEventView.h
//  calender
//
//  Created by xiangfang on 13-7-8.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedEventEntityExtra.h"
#import "UserEntityExtra.h"

#define BirthdayEventView_Height  55

@interface BirthdayEventView : UIView

@property IBOutlet UILabel * labTitle;
@property IBOutlet UIImageView * imgUser;
@property IBOutlet UIImageView * imgEventType;
/*
 Update the date in the View
 */
-(void) refreshView:(FeedEventEntity *) event;

/*
 Create a EventView object with default data
 */
+(BirthdayEventView *) createEventView;


@end
