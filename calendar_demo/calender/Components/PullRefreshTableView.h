
#import <UIKit/UIKit.h>

@protocol PullRefreshTableViewDelegate <NSObject>

-(void) onStartLoadData:(BOOL) head;

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
- (void)startTailerLoading;

- (void)stopPullLoading;

- (void)pullStarted;
- (void)pullCancelled;

-(BOOL) isLoading;

//For subclass overwrited, please don't call it
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
@end
