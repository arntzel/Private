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
    UIImage *bgImage = [UIImage imageNamed:@"addEventBtnBg.png"];
    bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [_view1 setImage:bgImage];
    [_view2 setImage:bgImage];
    [_view3 setImage:bgImage];
}

+(AddEventSettingView *) createEventSettingView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"AddEventSettingView" owner:self options:nil];
    AddEventSettingView * view = (AddEventSettingView*)[nibView objectAtIndex:0];
    [view initUI];
    return view;
}

- (void)dealloc {
    [_view1 release];
    [_view2 release];
    [_view3 release];
    [super dealloc];
}
@end
