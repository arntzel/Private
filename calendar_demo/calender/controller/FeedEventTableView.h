

#import <UIKit/UIKit.h>
#import "EventModel.h"

#import "PullRefreshTableView.h"

@protocol FeedEventTableViewDelegate <NSObject>

-(void) onDisplayFirstDayChanged:(NSDate *) firstDay;

@end

@interface FeedEventTableView : PullRefreshTableView

@property(assign) id<FeedEventTableViewDelegate> feedEventdelegate;

-(void) setEventModel:(EventModel *) eventModel;


@end
