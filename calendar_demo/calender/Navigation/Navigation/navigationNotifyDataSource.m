//
//  navigationNotifyDataSource.m
//  Navigation
//
//  Created by zyax86 on 13-6-11.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "navigationNotifyDataSource.h"

@interface navigationNotifyDataSource()
{
    NSArray *iconImageArray;
    NSArray *titleArray;
}
@end

@implementation navigationNotifyDataSource

- (id)init
{
    self = [super init];
    if (self) {
        iconImageArray = [NSArray arrayWithObjects:@"manuNavCal.png", @"manuNavQuestion.png", @"manuNavSetting.png", nil];
    }
    return self;
}

- (NSString *)iconImageAtIndex:(NSInteger)index
{
    return @"manuHeadImage.jpg";
    return [iconImageArray objectAtIndex:index];
}

- (NSString *)titleAtIndex:(NSInteger)index
{
    return @"Nick invited you to Designer News NY Meet-up";
    return [titleArray objectAtIndex:index];
}

- (NSInteger )heightForCellAtIndex:(NSInteger)index
{
    return 80;
}

- (NSInteger )numberOfObjects
{
    return 10;
}

@end