#import <UIKit/UIKit.h>
#import "Navigation.h"
#import "BaseUIViewController.h"
#import "LogUtil.h"
#import "CoreDataModel.h"

@class MainViewController;

@protocol BaseMenuViewControllerDelegate <NSObject>

-(void)onBtnMenuClick;
-(void)onBtnCalendarClick;

@end


@interface BaseMenuViewController : BaseUIViewController <PopDelegate>

@property (strong) Navigation * navigation;

//@property(weak) id<BaseMenuViewControllerDelegate> delegate;
@property (strong) MainViewController* delegate;

-(BOOL)prefersStatusBarHidden;
- (UIStatusBarStyle)preferredStatusBarStyle;

@end
