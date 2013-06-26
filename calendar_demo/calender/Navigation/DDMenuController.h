#import <UIKit/UIKit.h>

@interface MenuFlag : NSObject
{
    unsigned int showingLeftView;
    unsigned int showingRightView;
    unsigned int canShowRight;
    unsigned int canShowLeft;
}
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

@interface DDMenuController : UIViewController <UIGestureRecognizerDelegate>{
    
    id _tap;
    id _pan;
    
    CGFloat _panOriginX;
    CGPoint _panVelocity;
    DDMenuPanDirection _panDirection;

    
    MenuFlag *_menuFlags;
}

@property(nonatomic, strong) MenuFlag *menuFlags;

@property(nonatomic,strong) UIViewController *leftViewController;
@property(nonatomic,strong) UIViewController *rightViewController;
@property(nonatomic,strong) UIViewController *rootViewController;

@property(nonatomic,readonly) UITapGestureRecognizer *tap;
@property(nonatomic,readonly) UIPanGestureRecognizer *pan;

- (id)initWithRootViewController:(UIViewController*)controller;
- (void)setRootController:(UIViewController *)controller animated:(BOOL)animated; // used to push a new controller on the stack
- (void)showRootController:(BOOL)animated; // reset to "home" view controller
- (void)showRightController:(BOOL)animated;  // show right
- (void)showLeftController:(BOOL)animated;  // show left

@end