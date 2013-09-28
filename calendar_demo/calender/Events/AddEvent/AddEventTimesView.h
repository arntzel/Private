//
//  AddEventTimesView.h
//  Calvin
//
//  Created by xiangfang on 13-9-28.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EventDate.h"


@interface AddEventTimesView : UIView

-(void)addBtnTarget:(id)target action:(SEL)action;

-(void) addEventDate:(EventDate *) eventDate;

-(void) updateView:(NSArray *) eventDates;

-(NSArray *) getEventDates;

@end
