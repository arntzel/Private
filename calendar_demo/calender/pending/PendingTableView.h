
#import <UIKit/UIKit.h>

#import "Event.h"
#import "PullRefreshTableView.h"

@interface PendingTableView : PullRefreshTableView


-(void) setSectionHeader:(NSString *) header;

-(void) setCompletedEvents:(NSMutableArray *) completedEvts andPendingEvents:(NSMutableArray *) pendingEvs;

@end
