#import <Foundation/Foundation.h>
#import "EventTimePickerDefine.h"

@class CTimePicker;

@protocol TimePickerDelegate <NSObject>
- (void)timePicker:(CTimePicker *)picker changePickerType:(NSString *)datePickerType;
- (void)timeDidChanged:(CTimePicker *)picker;
@end

@interface CTimePicker : UIView
{
    NSInteger WIDTH_TYPE_PICKER;
    NSInteger WIDTH_DATE_PICKER;
    NSInteger WIDTH_HOUR_PICKER;
    NSInteger WIDTH_MIN_PICKER;
    NSInteger WIDTH_AMPM_PICKER;
}

@property(nonatomic, weak) id<TimePickerDelegate> delegate;

@property(nonatomic, strong) NSDate *markDay;
@property(nonatomic) NSInteger dayOffset;

@property(nonatomic) NSInteger currentType;
@property(nonatomic) NSInteger currentHour;
@property(nonatomic) NSInteger currentMin;
@property(nonatomic) NSInteger currentAMPM;

@property(nonatomic, strong) NSArray *dateTypeArray;
@property(nonatomic, strong) NSArray *ampmArray;
@property(nonatomic, strong) NSArray *monthNameArray;
@property(nonatomic, strong) NSArray *weekDayArray;

+ (NSString *)getCurrentDateDescriptionFromeDate:(NSDate *)date type:(NSString *)type;
+ (NSArray *)dateTypeArray;
+ (NSArray *)monthNameArray;
+ (NSArray *)weekDayArray;
+ (NSArray *)ampmArray;

- (NSString *)getCurrentDateDescription;
- (NSDate *)getCurrentDate;
- (id)initWithMarkDay:(NSDate *)day Type:(NSString *)type;

@end
