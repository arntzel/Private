//
//  AddEventSettingView.h
//  test
//
//  Created by zyax86 on 13-7-7.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSwitch.h"

@interface AddEventSettingView : UIView
@property (retain, nonatomic) IBOutlet UIImageView *view1;
@property (retain, nonatomic) IBOutlet UIImageView *view2;
@property (retain, nonatomic) IBOutlet UIImageView *view3;

+(AddEventSettingView *) createEventSettingView;

- (IBAction)proposeDaysClick:(id)sender;
- (IBAction)onlyProposeDaysClick:(id)sender;
- (IBAction)onlyProposeTimes:(id)sender;
- (IBAction)canntProposeDaysClick:(id)sender;

@property (retain, nonatomic) IBOutlet CustomSwitch *canInvitePeopleSwitch;
@property (retain, nonatomic) IBOutlet CustomSwitch *canChangeLocation;

@property (retain, nonatomic) IBOutlet UILabel *timeZoneLabel;


@end
