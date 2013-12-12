

#import <UIKit/UIKit.h>
#import "BaseMenuViewController.h"

@protocol FeedViewControllerDelegate <NSObject>
-(void)blurBackground;
-(void)unloadBlurBackground;
@end

@interface FeedViewController : BaseMenuViewController<UIGestureRecognizerDelegate>


@end
