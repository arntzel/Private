//
//  EventViewCell.h
//  Calvin
//
//  Created by Yevgeny on 3/2/14.
//  Copyright (c) 2014 Pencil Me, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FeedEventEntityExtra.h"
#import "UserEntityExtra.h"

#define PlanView_HEIGHT 120


@interface EventViewCell : UITableViewCell


@property IBOutlet UILabel * labTitle;
@property IBOutlet UILabel * labAttendees;
//@property IBOutlet UILabel * labTime;
//@property IBOutlet UILabel * labTimeType;
@property (weak, nonatomic) IBOutlet UIView *inviteesPanel;
@property (strong, nonatomic) IBOutlet UIImageView *iconLocation;
@property (strong, nonatomic) IBOutlet UIImageView *iconAttendee;
@property IBOutlet UILabel * labLocation;
@property IBOutlet UIImageView * imgUser;
@property IBOutlet UIImageView * imgStatus;
@property IBOutlet UIImageView * imgEventType;
//@property IBOutlet UILabel * labEventDuration;
@property IBOutlet UILabel *labTimeStr;
@property (weak, nonatomic) IBOutlet UIView *separator;

/*
 Update the date in the View
 */
-(void) refreshView:(FeedEventEntity *) event lastForThisDay:(BOOL)lastForThisDay;

-(float) getEventViewHeight;

@end
