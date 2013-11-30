//
//  LocationChangedViewController.h
//  Calvin
//
//  Created by tu on 13-11-29.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "SettingsBaseViewController.h"

@interface LocationChangedViewController : SettingsBaseViewController
@property (nonatomic, strong) NSDictionary *countryInfo;
@property (nonatomic, strong) NSString *zipCode;
@property (nonatomic, copy) void (^locationInfoChanged)(NSString *countryCode, NSString *zipCode);
@end
