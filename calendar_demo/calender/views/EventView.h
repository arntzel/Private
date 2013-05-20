//
//  PlanView.h
//  calender
//
//  Created by fang xiang on 13-5-4.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

#define PlanView_HEIGHT 105

@interface EventView : UIView

@property IBOutlet UILabel * labTitle;
@property IBOutlet UILabel * labAttendees;
@property IBOutlet UILabel * labTime;
@property IBOutlet UILabel * labLocation;
@property IBOutlet UIImageView * imgUser;
@property IBOutlet UIImageView * imgStatus;


-(void) refreshView:(Event *) event;

+(EventView *) createEventView;

@end
