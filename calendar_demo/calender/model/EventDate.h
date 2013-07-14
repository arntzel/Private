
#import <Foundation/Foundation.h>

#define START_TYPEEXACTLYAT  @"exactly_at"
#define START_TYPEWITHIN     @"within_an_hour"
#define START_TYPEAFTER      @"anytime_after"

@interface EventDate : NSObject

@property BOOL is_all_day;
@property(strong) NSString * duration;
@property int duration_days;
@property int duration_hours;
@property int duration_minutes;

@property(strong) NSString * start_type;
@property(strong) NSDate * start;

@property(strong) NSDate * end;

- (NSString *)parseStartTimeString;
- (NSString *)parseStartDateString;
- (NSString *)parseDuringDateString;

- (void)convertMinToQuarterMode;

@end
