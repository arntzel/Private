//
//  navigationMenuDataSource.h
//  Navigation
//
//  Created by zyax86 on 13-6-11.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface navigationMenuDataSource : NSObject

- (NSString *)iconImageAtIndex:(NSInteger)index;
- (NSString *)detailImageAtIndex:(NSInteger)index;
- (NSString *)titleAtIndex:(NSInteger)index;

- (NSInteger )numberOfObjects;

- (NSInteger )heightForCellAtIndex:(NSInteger)index;
@end
