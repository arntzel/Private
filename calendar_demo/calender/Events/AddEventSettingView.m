//
//  AddEventSettingView.m
//  test
//
//  Created by zyax86 on 13-7-7.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "AddEventSettingView.h"


@implementation AddEventSettingView

- (void)initUI
{
    [self setUserInteractionEnabled:YES];
//    UIImage *bgImage = [UIImage imageNamed:@"addEventBtnBg.png"];
//    bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
//    [_view1 setImage:bgImage];
//    [_view2 setImage:bgImage];
//    [_view3 setImage:bgImage];
    
    CGRect frame = self.canInvitePeopleSwitch.frame;
    [self.canInvitePeopleSwitch removeFromSuperview];
    self.canInvitePeopleSwitch = [[CustomSwitch alloc] initWithFrame:frame segmentCount:2];
    [self.canInvitePeopleSwitch setSegTitle:@"Yes" AtIndex:0];
    [self.canInvitePeopleSwitch setSegTitle:@"No" AtIndex:1];
    [_view2 addSubview:self.canInvitePeopleSwitch];
    
    frame = self.canChangeLocation.frame;
    [self.canChangeLocation removeFromSuperview];
    self.canChangeLocation = [[CustomSwitch alloc] initWithFrame:frame segmentCount:2];
    [self.canChangeLocation setSegTitle:@"Yes" AtIndex:0];
    [self.canChangeLocation setSegTitle:@"No" AtIndex:1];
    [_view2 addSubview:self.canChangeLocation];

//    [self.canInvitePeopleSwitch addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}

+(AddEventSettingView *) createEventSettingView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"AddEventSettingView" owner:self options:nil];
    AddEventSettingView * view = (AddEventSettingView*)[nibView objectAtIndex:0];
    [view initUI];
    return view;
}

- (IBAction)proposeDaysClick:(id)sender {
    [self reversSelectBtn:sender];
}

- (IBAction)onlyProposeDaysClick:(id)sender {
    [self reversSelectBtn:sender];
}

- (IBAction)onlyProposeTimes:(id)sender {
    [self reversSelectBtn:sender];
}

- (IBAction)canntProposeDaysClick:(id)sender {
    [self reversSelectBtn:sender];
}

- (void)reversSelectBtn:(UIButton *)btn
{
    btn.selected = !btn.selected;
}

- (void)dealloc {
    self.canChangeLocation = nil;
    self.canInvitePeopleSwitch = nil;
    
    [_view1 release];
    [_view2 release];
    [_view3 release];
    [super dealloc];
}
@end
