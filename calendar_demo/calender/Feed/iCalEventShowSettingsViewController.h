//
//  iCalEventShowSettingsViewController.h
//  Calvin
//
//  Created by tu on 13-12-22.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <EventKit/EventKit.h>
#import "BaseUIViewController.h"
#import "SettingsBaseViewController.h"
@interface iCalendar : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *iCalID;
@property (assign, nonatomic) BOOL isSelect;

@end


@interface iCalEventShowSettingsViewController : SettingsBaseViewController

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy) void (^dismissBlock)(NSArray *icalTypes);
@end
