
#import <UIKit/UIKit.h>

#import "Event.h"

@interface PendingTableView : UITableView


-(void) setSectionHeader:(NSString *) header;

-(void) setCompletedEvents:(NSMutableArray *) completedEvts andPendingEvents:(NSMutableArray *) pendingEvs;

@end
