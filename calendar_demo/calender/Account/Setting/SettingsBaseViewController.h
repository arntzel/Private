//
//  SettingsBaseViewController.h
//  Calvin
//
//  Created by tu changwei on 13-9-26.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "BaseUIViewController.h"
#import "BaseMenuViewController.h"
#import "DeviceInfo.h"
@interface SettingsBaseViewController : BaseUIViewController
@property Navigation * navigation;


#pragma mark - User Interaction
- (void)leftNavBtnClicked:(UIButton *)btn;
@end
