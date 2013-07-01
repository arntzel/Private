

#import <UIKit/UIKit.h>
#import "Navigation.h"

@protocol BaseMenuViewControllerDelegate <NSObject>

-(void)onBtnMenuClick;

@end


@interface BaseMenuViewController : UIViewController

@property Navigation * navigation;

@property(weak) id<BaseMenuViewControllerDelegate> delegate;

@end
