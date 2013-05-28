//
//  GPlaceApi.h
//  calender
//
//  Created by zyax86 on 13-5-28.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "googleAPIKey.h"


@protocol GPlaceApiDelegate

- (void)upDateWithArray:(NSArray *)array;

@end

@interface GPlaceApi : NSObject
- (void)startRequestWithStringQuery:(NSString *)query;

@property(nonatomic,weak) id<GPlaceApiDelegate> delegate;
@end
