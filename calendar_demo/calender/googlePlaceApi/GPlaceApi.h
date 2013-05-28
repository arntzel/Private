//
//  GPlaceApi.h
//  calender
//
//  Created by zyax86 on 13-5-28.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "googleAPIKey.h"

@class GPlaceApi;
@protocol GPlaceApiDelegate

- (void)upDateWithArray:(NSArray *)array GPlaceApi:(GPlaceApi*)api;

@end

@interface GPlaceApi : NSObject
- (void)startRequestWithTxtSearchQuery:(NSString *)query;

- (void)startRequestWithNearBySearchQuery:(CGPoint)place Radius:(NSInteger)radius;

@property(nonatomic,weak) id<GPlaceApiDelegate> delegate;
@end
