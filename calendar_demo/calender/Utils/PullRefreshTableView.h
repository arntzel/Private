
#import <UIKit/UIKit.h>

@interface PullRefreshTableView : UITableView

@property (nonatomic, assign) BOOL headerEnabled;
@property (nonatomic, assign) BOOL tailerEnabled;
@property (nonatomic, assign) int upTimes;
@property (nonatomic, assign) int downTimes;

- (void)startHeaderLoading;
- (void)stopPullLoading;

- (void)pullStarted;
- (void)pullCancelled;

@end
