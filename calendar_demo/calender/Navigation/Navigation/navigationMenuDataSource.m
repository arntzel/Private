//
//  navigationMenuDataSource.m
//  Navigation
//
//  Created by zyax86 on 13-6-11.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "navigationMenuDataSource.h"

@interface navigationMenuDataSource()
{
    NSArray *iconImageArray;
    NSArray *detailImageArray;
    
    NSArray *titleArray;
}
@end

@implementation navigationMenuDataSource

- (id)init
{
    self = [super init];
    if (self) {
        iconImageArray = [NSArray arrayWithObjects:@"manuNavCal.png", @"manuNavQuestion.png", @"", nil];
        [iconImageArray retain];
        
        detailImageArray = [NSArray arrayWithObjects:@"", @"", @"manuNavSetting.png", nil];
        [detailImageArray retain];
        
        titleArray = [NSArray arrayWithObjects:@"Calendar", @"Pending", @"Dov Mamann", nil];
        [titleArray retain];
    }
    return self;
}

- (NSString *)iconImageAtIndex:(NSInteger)index
{
    return [iconImageArray objectAtIndex:index];
}

- (NSString *)detailImageAtIndex:(NSInteger)index
{
    return [detailImageArray objectAtIndex:index];
}

- (NSString *)titleAtIndex:(NSInteger)index
{
    return [titleArray objectAtIndex:index];
}

- (NSInteger )heightForCellAtIndex:(NSInteger)index
{
    return 55;
}

- (NSInteger )numberOfObjects
{
    return 3;
}

@end
