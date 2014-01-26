

#import <UIKit/UIKit.h>
#import "BaseMenuViewController.h"

@protocol FeedViewControllerDelegate <NSObject>
@optional
-(void)blurBackground;
-(void)unloadBlurBackground;
-(void)scrollToTodayFeeds;

-(void)disableCalendarBouns;
@end

@interface FeedViewController : BaseMenuViewController<UIGestureRecognizerDelegate>

-(void)playCalendarAnimation;

@end
