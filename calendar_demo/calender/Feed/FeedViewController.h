

#import <UIKit/UIKit.h>
#import "BaseMenuViewController.h"

@protocol FeedViewControllerDelegate <NSObject>
@optional
-(void)blurBackground;
-(void)unloadBlurBackground;
-(void)scrollToTodayFeeds;
@end

@interface FeedViewController : BaseMenuViewController<UIGestureRecognizerDelegate>


@end
