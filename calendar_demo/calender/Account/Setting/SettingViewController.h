//
//  SettingViewController.h
//  calender
//
//  Created by xiangfang on 13-8-4.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsBaseViewController.h"

@interface SettingViewController : SettingsBaseViewController 



@property(weak) id<BaseMenuViewControllerDelegate> delegate;

-(IBAction) logout:(id)sender;

@end
