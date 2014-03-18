

#import <UIKit/UIKit.h>

#import "PullRefreshTableView.h"
#import "CoreDataModel.h"


#define DAY (60*60*24)

#define HEADER_HEIGHT 28
#define NO_EVENTS_HEADER_CELL 31

#define TAG_SECTION_TEXT_LABEL 555
#define TAG_SECTION_TEXT_LABEL_LEFT 556


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//一天的所有FeedEvent集合
@interface DayFeedEventEntitys : NSObject

@property(retain) NSString * day;

//eventtype's filter
@property int filter;

-(void) resetFilterEvents;

-(NSArray*) getFilterEvents:(int)eventTypefilter;

-(void) addEvent:(FeedEventEntity *) event;

@end




@protocol FeedEventTableViewDelegate <NSObject>

-(void) onDisplayFirstDayChanged:(NSDate *) firstDay;

-(void) onAddNewEvent:(NSDate *) date;

@end

@interface FeedEventTableView : UITableView

@property (nonatomic) NSUInteger currentSection;
@property int eventTypeFilters;

@property(assign) id<FeedEventTableViewDelegate> feedEventdelegate;
@property(assign) id<PopDelegate> popDelegate;

-(void) reloadFeedEventEntitys:(NSDate *) day;

-(void)scroll2SelectedDate:(NSString *) day;

-(void) scroll2Date:(NSString *) day animated:(BOOL) animated;

-(void) scroll2Event:(FeedEventEntity *) event animated:(BOOL) animated;


-(NSDate *) getFirstVisibleDay;

@end
