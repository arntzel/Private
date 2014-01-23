

#import <Foundation/Foundation.h>
#import "EventTimeVote.h"


#define START_TYPEEXACTLYAT  @"exactly_at"
#define START_TYPEWITHIN     @"within_an_hour"
#define START_TYPEAFTER      @"anytime_after"


@interface ProposeStart : NSObject <NSCopying>

@property int id;

@property(strong) NSDate * start;
@property(strong) NSDate * end;

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
- (NSString *)parseStartTimeStringWithFirstCapitalized;
- (NSString *)parseStartDateString;
- (NSString *)parseDuringDateString;
- (NSString *)parseDuringDateString2;

- (void)convertMinToQuarterMode;


- (NSComparisonResult)compare:(id)inObject;

-(BOOL) isEqual:(id)object;


-(NSDate *) getEndTime;

-(NSString *) getVoteTimeLabel;

-(NSDictionary*) convent2Dic;

-(int) getDurationMins;

-(int) getAcceptCount;

-(int) getDeclinedCount;

+(ProposeStart *) parse:(NSDictionary *) json;


@end
