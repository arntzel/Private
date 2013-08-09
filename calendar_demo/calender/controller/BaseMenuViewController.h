

#import <UIKit/UIKit.h>
#import "Navigation.h"
#import "BaseUIViewController.h"

@protocol BaseMenuViewControllerDelegate <NSObject>

-(void)onBtnMenuClick;

@end


@interface BaseMenuViewController : BaseUIViewController

@property Navigation * navigation;

@property(weak) id<BaseMenuViewControllerDelegate> delegate;


-(BOOL)prefersStatusBarHidden;

@end
