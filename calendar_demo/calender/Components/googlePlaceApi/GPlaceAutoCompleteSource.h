//
//  GPlaceDataSource.h
//  calender
//
//  Created by zyax86 on 13-5-28.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GPlaceAutoCompleteSource;

@protocol GPlaceAutoCompleteSourceDelegate <NSObject>

- (void)didSelectPlaceWithName:(NSString *)placeName GPlaceDataSource:(GPlaceAutoCompleteSource*)dataSource;

@end

@interface GPlaceAutoCompleteSource : NSObject<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,assign) id<GPlaceAutoCompleteSourceDelegate> delegate;

- (void)setData:(NSArray *)data;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
