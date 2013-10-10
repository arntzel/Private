//
//  ProposeStart.h
//  Calvin
//
//  Created by xiangfang on 13-9-23.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventTimeVote.h"


#define START_TYPEEXACTLYAT  @"exactly_at"
#define START_TYPEWITHIN     @"within_an_hour"
#define START_TYPEAFTER      @"anytime_after"


@interface ProposeStart : NSObject <NSCopying>

@property int id;

@property(strong) NSDate * start;

@property(strong) NSString * start_type;

//EventTimeVote list
@property(strong) NSArray * votes;


@property int duration_days;
@property int duration_hours;
@property int duration_minutes;

@property BOOL is_all_day;


//Is the final time of the event
@property int finalized;

- (NSString *)parseStartTimeString;
- (NSString *)parseStartDateString;
- (NSString *)parseDuringDateString;

- (void)convertMinToQuarterMode;


- (NSComparisonResult)compare:(id)inObject;


-(NSDate *) getEndTime;

-(NSDictionary*) convent2Dic;

+(ProposeStart *) parse:(NSDictionary *) json;


@end
