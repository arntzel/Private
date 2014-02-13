
#import <UIKit/UIKit.h>

#import "FeedEventEntity.h"
#import "CoreDataModel.h"

@interface PendingTableView : UITableView


-(void) setSectionHeader:(NSString *) header;

-(void) setCompletedEvents:(NSMutableArray *) completedEvts andPendingEvents:(NSMutableArray *) pendingEvs;

@property(assign) id<PopDelegate> popDelegate;

@end
