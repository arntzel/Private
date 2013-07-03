
#import <UIKit/UIKit.h>

#import "Event.h"
#import "PullRefreshTableView.h"

@protocol PendingTableViewDalegate <NSObject>

-(void) onStartLoadData;

@end

@interface PendingTableView : PullRefreshTableView


-(void) setSectionHeader:(NSString *) header;

-(void) setCompletedEvents:(NSMutableArray *) completedEvts andPendingEvents:(NSMutableArray *) pendingEvs;

@property(nonatomic, assign) id<PendingTableViewDalegate>  dataDalegate;

@end
