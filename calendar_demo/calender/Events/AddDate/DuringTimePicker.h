//
//  DuringTimePicker.h
//  AddDate
//
//  Created by zyax86 on 13-7-2.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DuringTimePickerDelegate <NSObject>

- (void)setDurationAllDay:(BOOL)allDay;
- (void)setDurationDays:(NSInteger)days;
- (void)setDurationHours:(NSInteger)hours Minutes:(NSInteger)minutes;

@end

@interface DuringTimePicker : UIView
@property(nonatomic,assign) id<DuringTimePickerDelegate> delegate;

- (id)init;

- (void)setHours:(NSInteger)hours_ Minutes:(NSInteger)minutes_ Animation:(BOOL)animation;
- (void)setAllDays:(NSInteger)allDays_ Animation:(BOOL)animation;
- (void)setisAllDate:(BOOL)isAllDay;

@end
