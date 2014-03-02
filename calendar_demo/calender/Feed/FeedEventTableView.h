

#import <UIKit/UIKit.h>

#import "PullRefreshTableView.h"
#import "CoreDataModel.h"

@protocol FeedEventTableViewDelegate <NSObject>

-(void) onDisplayFirstDayChanged:(NSDate *) firstDay;

-(void) onAddNewEvent;

@end

@interface FeedEventTableView : UITableView

@property int eventTypeFilters;

@property(assign) id<FeedEventTableViewDelegate> feedEventdelegate;
@property(assign) id<PopDelegate> popDelegate;

-(void) reloadFeedEventEntitys:(NSDate *) day;

-(void)scroll2SelectedDate:(NSString *) day;

-(void) scroll2Date:(NSString *) day animated:(BOOL) animated;

-(NSDate *) getFirstVisibleDay;

@end
