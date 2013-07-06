//
//  GPlaceDataSource.h
//  calender
//
//  Created by zyax86 on 13-5-28.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@class GPlaceDataSource;

@protocol GPlaceDataSourceDelegate <NSObject>

- (void)didSelectPlace:(Location *)location GPlaceDataSource:(GPlaceDataSource*)dataSource;

@end

@interface GPlaceDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,assign) id<GPlaceDataSourceDelegate> delegate;

- (void)setData:(NSArray *)data;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
