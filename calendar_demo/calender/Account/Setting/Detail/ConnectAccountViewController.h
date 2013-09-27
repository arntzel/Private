//
//  ConnectAccountViewController.h
//  Calvin
//
//  Created by tu changwei on 13-9-27.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "SettingsBaseViewController.h"
typedef enum ConnectType
{
    ConnectGoogle = 1,
    ConnectFacebook,
    
}connectType;

@interface ConnectAccountViewController : SettingsBaseViewController

@property (assign, nonatomic) connectType type;

@end
