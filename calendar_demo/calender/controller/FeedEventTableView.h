

#import <UIKit/UIKit.h>
#import "EventModel.h"

#import "PullRefreshTableView.h"

@protocol FeedEventTableViewDelegate <NSObject>

-(void) onDisplayFirstDayChanged:(NSDate *) firstDay;

@end

@interface FeedEventTableView : UITableView

@property(strong) NSDate * beginDate;
@property(strong) NSDate * lastEventUpdateTime;

@property int eventTypeFilters;

@property(assign) id<FeedEventTableViewDelegate> feedEventdelegate;


@end
