#import <UIKit/UIKit.h>

#import "CoreDataModel.h"
#import "BaseMenuViewController.h"

@protocol FeedViewControllerDelegate <NSObject>

@optional
-(void)blurBackground;
-(void)unloadBlurBackground;
-(void)scrollToTodayFeeds;

-(void)disableCalendarBouns;
@end

@interface FeedViewController : BaseMenuViewController<UIGestureRecognizerDelegate, CoreDataModelDelegate>

-(void)playCalendarAnimation;

@property(assign) id<PopDelegate> popDelegate;


@end
