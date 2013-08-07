

#import <UIKit/UIKit.h>
#import "EventModel.h"

#import "PullRefreshTableView.h"

@protocol FeedEventTableViewDelegate <NSObject>

-(void) onDisplayFirstDayChanged:(NSDate *) firstDay;

@end

@interface FeedEventTableView : UITableView

@property(strong) NSDate * lastEventUpdateTime;

@property int eventTypeFilters;

@property(assign) id<FeedEventTableViewDelegate> feedEventdelegate;


-(void) reloadFeedEventEntitys:(NSDate *) day;


-(void)scroll2SelectedDate:(NSString *) day;

-(void) scroll2Date:(NSString *) day animated:(BOOL) animated;

@end
