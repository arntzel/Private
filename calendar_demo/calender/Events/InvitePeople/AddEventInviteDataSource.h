//
//  AddEventInviteDataSource.h
//  calender
//
//  Created by zyax86 on 13-7-6.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddEventInviteDataSource : NSObject<UITableViewDataSource>

- (NSString *)nameAtIndex:(NSInteger)index;

- (void)setSelectedAtIndex:(NSInteger)index;
- (void)setDeselectedAtIndex:(NSInteger)index;
@end
