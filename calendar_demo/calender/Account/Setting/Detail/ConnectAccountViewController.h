//
//  ConnectAccountViewController.h
//  Calvin
//
//  Created by tu changwei on 13-9-27.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "SettingsBaseViewController.h"
#import "SettingsModel.h"
//typedef enum
//{
//    ConnectGoogle = 1,
//    ConnectFacebook,
//    
//}ConnectType;

@interface ConnectAccountViewController : SettingsBaseViewController

@property (assign, nonatomic) ConnectType type;

@end
