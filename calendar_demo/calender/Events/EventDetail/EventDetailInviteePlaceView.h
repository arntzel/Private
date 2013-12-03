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

@protocol EventDetailInviteePlaceViewDelegate <NSObject>

- (void) onInviteeViewClicked;

- (void)changeLocation;
- (void)viewInMaps;
- (void)frameDidChanged;

@end

@interface EventDetailInviteePlaceView : UIView

@property(nonatomic, assign) id<EventDetailInviteePlaceViewDelegate> delegate;

- (void) updateUI;

- (void) setDesciption:(NSString *) desc;

- (id)initByCreator:(BOOL)creator CanChangeLocation:(BOOL)canChangeLocation;

- (void)updateInvitee:(NSArray *) users;

- (void) setLocation:(Location*) location;

@end
