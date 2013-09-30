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

@property (nonatomic, copy) void (^updataLeftNavBlock)(void);
@property (nonatomic, assign) BOOL nameChanged;
@property(weak) id<BaseMenuViewControllerDelegate> delegate;

-(IBAction) logout:(id)sender;
- (void)updataUserProfile:(NSString *)avatar_url;
- (void)dismissKeyBoard:(id)sender;
@end
