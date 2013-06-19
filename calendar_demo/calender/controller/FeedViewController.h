

#import <UIKit/UIKit.h>

@protocol FeedViewControllerDelegate <NSObject>

-(void)onBtnMenuClick;

@end

@interface FeedViewController : UIViewController

@property(weak) id<FeedViewControllerDelegate> delegate;

@end
