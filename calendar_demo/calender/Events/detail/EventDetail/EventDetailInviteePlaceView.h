//
//  EventDetailInviteePlaceView.h
//  detail
//
//  Created by zyax86 on 13-8-4.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventDetailInviteeView.h"
#import "EventDetailPlaceView.h"

@interface EventDetailInviteePlaceView : UIView


@property(retain, nonatomic) EventDetailInviteeView *inviteeView;
@property(retain, nonatomic) EventDetailPlaceView *placeView;

- (id)init;


@end
