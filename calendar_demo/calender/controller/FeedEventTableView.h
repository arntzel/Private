

#import <UIKit/UIKit.h>
#import "EventModel.h"

#import "PullRefreshTableView.h"

@interface FeedEventTableView : PullRefreshTableView

-(void) setEventModel:(EventModel *) eventModel;

@end
