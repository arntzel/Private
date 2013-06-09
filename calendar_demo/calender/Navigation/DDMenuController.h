#import <UIKit/UIKit.h>

@interface MenuFlag : NSObject
{
    unsigned int respondsToWillShowViewController;
    unsigned int showingLeftView;
    unsigned int showingRightView;
    unsigned int canShowRight;
    unsigned int canShowLeft;
}
@property(nonatomic,assign) unsigned int respondsToWillShowViewController;
@property(nonatomic,assign) unsigned int showingLeftView;
@property(nonatomic,assign) unsigned int showingRightView;
@property(nonatomic,assign) unsigned int canShowRight;
@property(nonatomic,assign) unsigned int canShowLeft;
@end




typedef enum {
    DDMenuPanDirectionLeft = 0,
    DDMenuPanDirectionRight,
} DDMenuPanDirection;

typedef enum {
    DDMenuPanCompletionLeft = 0,
    DDMenuPanCompletionRight,
    DDMenuPanCompletionRoot,
} DDMenuPanCompletion;

@protocol DDMenuControllerDelegate;
@interface DDMenuController : UIViewController <UIGestureRecognizerDelegate>{
    
    id _tap;
    id _pan;
    
    CGFloat _panOriginX;
    CGPoint _panVelocity;
    DDMenuPanDirection _panDirection;

    
    MenuFlag *_menuFlags;
    
//    struct MenuFlag{
//        unsigned int respondsToWillShowViewController:1;
//        unsigned int showingLeftView:1;
//        unsigned int showingRightView:1;
//        unsigned int canShowRight:1;
//        unsigned int canShowLeft:1;
//    } _menuFlags;
    
}

@property(nonatomic, strong) MenuFlag *menuFlags;

- (id)initWithRootViewController:(UIViewController*)controller;

@property(nonatomic,assign) id<DDMenuControllerDelegate> delegate;

@property(nonatomic,strong) UIViewController *leftViewController;
@property(nonatomic,strong) UIViewController *rightViewController;
@property(nonatomic,strong) UIViewController *rootViewController;

@property(nonatomic,readonly) UITapGestureRecognizer *tap;
@property(nonatomic,readonly) UIPanGestureRecognizer *pan;

- (void)setRootController:(UIViewController *)controller animated:(BOOL)animated; // used to push a new controller on the stack
- (void)showRootController:(BOOL)animated; // reset to "home" view controller
- (void)showRightController:(BOOL)animated;  // show right
- (void)showLeftController:(BOOL)animated;  // show left

@end

@protocol DDMenuControllerDelegate 
- (void)menuController:(DDMenuController*)controller willShowViewController:(UIViewController*)controller;
@end