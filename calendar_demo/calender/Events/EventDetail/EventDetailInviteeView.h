//
//  EventDetailInviteeView.h
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "EventAttendee.h"

@interface EventDetailInviteeView : UIView

@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UIImageView *bgView;
@property (retain, nonatomic) IBOutlet UILabel *inviteeLabel;
@property (retain, nonatomic) IBOutlet UILabel *inviteeNamesLabel;
@property (retain, nonatomic) IBOutlet UIImageView *arrawView;



+(EventDetailInviteeView *) creatView;

//users is Contact array
- (void)updateInvitee:(NSArray *) users;

@end
