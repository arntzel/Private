

#import <UIKit/UIKit.h>
#import "Navigation.h"
#import "BaseUIViewController.h"
#import "LogUtil.h"

@protocol BaseMenuViewControllerDelegate <NSObject>

-(void)onBtnMenuClick;

@end


@interface BaseMenuViewController : BaseUIViewController

@property (strong) Navigation * navigation;

@property(weak) id<BaseMenuViewControllerDelegate> delegate;


-(BOOL)prefersStatusBarHidden;
- (UIStatusBarStyle)preferredStatusBarStyle;

@end
