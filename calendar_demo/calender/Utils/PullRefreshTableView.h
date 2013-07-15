
#import <UIKit/UIKit.h>

@protocol PullRefreshTableViewDelegate <NSObject>

-(void) onStartLoadData;

- (void) onPullStarted;

-(void) onPullStop;

- (void) onPullCancelled;

@end


@interface PullRefreshTableView : UITableView

@property (nonatomic, assign) BOOL headerEnabled;
@property (nonatomic, assign) BOOL tailerEnabled;
@property (nonatomic, assign) int upTimes;
@property (nonatomic, assign) int downTimes;

@property (nonatomic, assign) id<PullRefreshTableViewDelegate> pullRefreshDalegate;

- (void)startHeaderLoading;
- (void)stopPullLoading;

- (void)pullStarted;
- (void)pullCancelled;

-(BOOL) isLoading;

@end
