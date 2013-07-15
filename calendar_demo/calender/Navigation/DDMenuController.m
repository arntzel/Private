

#import "DDMenuController.h"


#import <QuartzCore/QuartzCore.h>
#import "KalView.h"

#import "KalTileView.h"
#import "KalWeekGridView.h"
#import "KalWeekView.h"

#import "KalGridView.h"
#import "KalMonthView.h"

#define kMenuFullWidth 320.0f
#define kMenuDisplayedWidth 256.0f
#define kMenuOverlayWidth (self.view.bounds.size.width - kMenuDisplayedWidth)
#define kMenuBounceOffset 30.0f
#define kMenuBounceDuration .3f
#define kMenuSlideDuration .5f

@implementation MenuFlag
@synthesize showingLeftView;
@synthesize showingRightView;
@synthesize canShowRight;
@synthesize canShowLeft;
@end

@interface DDMenuController (Internal) 
- (void)showShadow:(BOOL)val;
@end

@implementation DDMenuController

@synthesize menuFlags = _menuFlags;

@synthesize leftViewController=_left;
@synthesize rootViewController=_root;

@synthesize tap=_tap;
@synthesize pan=_pan;


- (id)initWithRootViewController:(UIViewController*)controller {
    if ((self = [super init])) {
        _root = controller;
        _menuFlags = [[MenuFlag alloc] init];
        _menuFlags.showingLeftView = 0;
        _menuFlags.canShowLeft = 1;
    }
    return self;
}

- (id)init {
    if ((self = [super init])) {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRootViewController:_root]; // reset root
    
    [self addTapGesture];
    
}
#pragma mark - GestureRecognizers

- (void)addTapGesture
{
    if (!_tap) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
        tap.delegate = (id<UIGestureRecognizerDelegate>)self;
        [self.view addGestureRecognizer:tap];
        [tap setEnabled:NO];
        _tap = tap;
    }
}

- (void)addPanGesture
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    pan.delegate = (id<UIGestureRecognizerDelegate>)self;
    [_root.view addGestureRecognizer:pan];
    _pan = pan;
}

- (void)tapGestureRecognizer:(UITapGestureRecognizer*)gesture {
    [self showRootController:YES];
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer*)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        [self showShadow:YES];
        _panOriginX = _root.view.frame.origin.x;
        _panVelocity = CGPointMake(0.0f, 0.0f);
        
        if([gesture velocityInView:self.view].x > 0) {
            _panDirection = DDMenuPanDirectionRight;
        } else {
            _panDirection = DDMenuPanDirectionLeft;
        }
    }
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint velocity = [gesture velocityInView:self.view];
        LOG_D(@"velocity.x:%f,velocity.y:%f", velocity.x, velocity.y);
        
        if((velocity.x*_panVelocity.x + velocity.y*_panVelocity.y) < 0) {
            _panDirection = (_panDirection == DDMenuPanDirectionRight) ? DDMenuPanDirectionLeft : DDMenuPanDirectionRight;
        }
        
        _panVelocity = velocity;
        CGPoint translation = [gesture translationInView:self.view];

        CGRect frame = _root.view.frame;
        frame.origin.x = _panOriginX + translation.x;
        
        if (frame.origin.x > 0.0f)
        {
            if (!_menuFlags.showingLeftView) {
                
                _menuFlags.showingLeftView = YES;
                CGRect frame = self.view.bounds;
                frame.size.width = kMenuFullWidth;
                self.leftViewController.view.frame = frame;
                [self.view insertSubview:self.leftViewController.view atIndex:0];
                
            }

            _root.view.frame = frame;
        }
        else
        {
            frame.origin.x = 0;
            _root.view.frame = frame;
        }

    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        
        //  Finishing moving to left, right or root view with current pan velocity
        [self.view setUserInteractionEnabled:NO];
        
        DDMenuPanCompletion completion = DDMenuPanCompletionRoot; // by default animate back to the root
        
        /*
        if (_panDirection == DDMenuPanDirectionRight && _menuFlags.showingLeftView)
        {
            completion = DDMenuPanCompletionLeft;
        }
         */
        
        
        
        CGPoint velocity = [gesture velocityInView:self.view];
        
        LOG_D(@"touch end. velocity.x:%f,velocity.y:%f", velocity.x, velocity.y);
        
        if (velocity.x < 0.0f)
        {
            velocity.x *= -1.0f;
        }
        BOOL bounce = (velocity.x > 800);
        CGFloat originX = _root.view.frame.origin.x;
        CGFloat width = _root.view.frame.size.width;
        CGFloat span = (width - kMenuOverlayWidth);
        CGFloat duration = kMenuSlideDuration;

        //超过此位置显示leftView
        if(originX>120) {
            completion = DDMenuPanCompletionLeft;
        }
        
        
        if (completion != DDMenuPanCompletionLeft) {
            bounce = NO;
        }
        
        if (bounce) {
            duration = (span / velocity.x);
        } else {
            duration = ((span - originX) / span) * duration;
        }
        
        [CATransaction begin];
        [CATransaction setCompletionBlock:^
        {
            if (completion == DDMenuPanCompletionLeft) {
                [self showLeftController:NO];
            }
            else
            {
                [self showRootController:NO];
            }
            [_root.view.layer removeAllAnimations];
            [self.view setUserInteractionEnabled:YES];
        }];
        
        CGPoint pos = _root.view.layer.position;
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        
        NSMutableArray *keyTimes = [[NSMutableArray alloc] initWithCapacity:bounce ? 3 : 2];
        NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:bounce ? 3 : 2];
        NSMutableArray *timingFunctions = [[NSMutableArray alloc] initWithCapacity:bounce ? 3 : 2];
        
        [values addObject:[NSValue valueWithCGPoint:pos]];
        [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [keyTimes addObject:[NSNumber numberWithFloat:0.0f]];
        
        if (bounce)
        {
            duration += kMenuBounceDuration;
            [keyTimes addObject:[NSNumber numberWithFloat:1.0f - ( kMenuBounceDuration / duration)]];
            if (completion == DDMenuPanCompletionLeft)
            {
                [values addObject:[NSValue valueWithCGPoint:CGPointMake(((width/2) + span) + kMenuBounceOffset, pos.y)]];
            }
            else
            {
                if (_panDirection == DDMenuPanDirectionLeft)
                {
                    [values addObject:[NSValue valueWithCGPoint:CGPointMake((width/2) - kMenuBounceOffset, pos.y)]];
                }
                else
                {
                    [values addObject:[NSValue valueWithCGPoint:CGPointMake((width/2) + kMenuBounceOffset, pos.y)]];
                }
            }
            [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        }
        
        if (completion == DDMenuPanCompletionLeft)
        {
            [values addObject:[NSValue valueWithCGPoint:CGPointMake((width/2) + span, pos.y)]];
        }
        else
        {
            [values addObject:[NSValue valueWithCGPoint:CGPointMake(width/2, pos.y)]];
        }
        
        [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [keyTimes addObject:[NSNumber numberWithFloat:1.0f]];
        
        animation.timingFunctions = timingFunctions;
        animation.keyTimes = keyTimes;
        animation.values = values;
        animation.duration = duration;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [_root.view.layer addAnimation:animation forKey:nil];
        [CATransaction commit];
    }
}




#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // Check for horizontal pan gesture
    if (gestureRecognizer == _pan) {
        CGPoint pointInRoot = [gestureRecognizer locationInView:_root.view];
        if (CGRectContainsPoint(_root.view.bounds, pointInRoot)) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    if (gestureRecognizer == _tap) {
        
        if (_root && (_menuFlags.showingRightView || _menuFlags.showingLeftView)) {
            return CGRectContainsPoint(_root.view.frame, [gestureRecognizer locationInView:self.view]);
        }
        
        return NO;
        
    }
    
    return YES;
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if(_menuFlags.showingLeftView == NO)
    {
        if ([touch.view isKindOfClass:[KalTileView class]] ||
            [touch.view isKindOfClass:[KalWeekGridView class]] ||
            [touch.view isKindOfClass:[KalWeekView class]] ||
            [touch.view isKindOfClass:[KalGridView class]] ||
            [touch.view isKindOfClass:[KalMonthView class]] ||
            [touch.view isKindOfClass:[KalView class]]) {
            return NO; // ignore the touch in these views
        }
    }
    return YES;
}


#pragma Internal Nav Handling
- (void)showShadow:(BOOL)val {
    if (!_root) return;
    
    _root.view.layer.shadowOpacity = val ? 0.8f : 0.0f;
    if (val) {
        _root.view.layer.cornerRadius = 4.0f;
        _root.view.layer.shadowOffset = CGSizeZero;
        _root.view.layer.shadowRadius = 4.0f;
        _root.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    }
    
}

- (void)showRootController:(BOOL)animated {
    [_tap setEnabled:NO];
    
    CGRect frame = _root.view.frame;
    frame.origin.x = 0.0f;
    
    BOOL _enabled = [UIView areAnimationsEnabled];
    if (!animated) {
        [UIView setAnimationsEnabled:NO];
    }

    [UIView animateWithDuration:.3 animations:^{
        _root.view.frame = frame;
    }
    completion:^(BOOL finished)
    {
        if (_left && _left.view.superview) {
            [_left.view removeFromSuperview];
        }
        _menuFlags.showingLeftView = NO;
        [self showShadow:NO];
    }];
    if (!animated) {
        [UIView setAnimationsEnabled:_enabled];
    }
    
}

- (void)showLeftController:(BOOL)animated {
    if (_menuFlags.showingLeftView == YES && animated) {
        [self showRootController:YES];
        return;
    }
    _menuFlags.showingLeftView = YES;
    [self showShadow:YES];
    
    UIView *view = self.leftViewController.view;
	CGRect frame = self.view.bounds;
	frame.size.width = kMenuFullWidth;
    view.frame = frame;
    [self.view insertSubview:view atIndex:0];
    [self.leftViewController viewWillAppear:animated];
    
    frame = _root.view.frame;
    frame.origin.x = CGRectGetMaxX(view.frame) - (kMenuFullWidth - kMenuDisplayedWidth);
    
    BOOL _enabled = [UIView areAnimationsEnabled];
    if (!animated) {
        [UIView setAnimationsEnabled:NO];
    }
    
    [UIView animateWithDuration:.3 animations:^{
        _root.view.frame = frame;
    } completion:^(BOOL finished) {
        [_tap setEnabled:YES];
    }];
    
    if (!animated) {
        [UIView setAnimationsEnabled:_enabled];
    }
    
}

#pragma mark Setters

- (void)setLeftViewController:(UIViewController *)leftController {
    _left = leftController;
    _menuFlags.canShowLeft = (_left!=nil);
}

- (void)setRootViewController:(UIViewController *)rootViewController {
    UIViewController *tempRoot = _root;
    _root = rootViewController;
    
    if (_root) {
        if (tempRoot) {
            [tempRoot.view removeFromSuperview];
            tempRoot = nil;
        }
        
        UIView *view = _root.view;
        view.frame = self.view.bounds;
        [self.view addSubview:view];
        
        [self addPanGesture];
        
    } else {
        if (tempRoot) {
            [tempRoot.view removeFromSuperview];
            tempRoot = nil;
        }
        
    }
}

- (void)setRootController:(UIViewController *)controller animated:(BOOL)animated {
    
    if (!controller) {
        [self setRootViewController:controller];
        return;
    }
    
    if (_menuFlags.showingLeftView) {
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        // slide out then come back with the new root
        __block DDMenuController *selfRef = self;
        __block UIViewController *rootRef = _root;
        CGRect frame = rootRef.view.frame;
        frame.origin.x = rootRef.view.bounds.size.width;
        
        [UIView animateWithDuration:.1 animations:^{
            
            rootRef.view.frame = frame;
            
        } completion:^(BOOL finished) {
            
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            [selfRef setRootViewController:controller];
            _root.view.frame = frame;
            [selfRef showRootController:animated];
            
        }];
        
    } else {
        
        // just add the root and move to it if it's not center
        [self setRootViewController:controller];
        [self showRootController:animated];
        
    }
    
}

#pragma mark - Actions

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return self.rootViewController.supportedInterfaceOrientations;
}



@end
