//
//  EventModel.h
//  calender
//
//  Created by xiangfang on 13-6-20.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventModel : NSObject


-(void) setEvents:(NSArray *) events forMonth:(NSString*) month;


-(NSArray *) getEventsByMonth:(NSString *) month;

-(NSArray *) getEventsByDay:(NSString *) day;

-(NSArray *) getAllDays;


@end
