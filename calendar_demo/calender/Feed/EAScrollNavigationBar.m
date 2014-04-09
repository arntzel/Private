//
//  EAScrollNavigationBar.m
//  Calvin
//
//  Created by Eliot Arntz on 4/2/14.
//  Copyright (c) 2014 Pencil Me, Inc. All rights reserved.
//

#import "EAScrollNavigationBar.h"
#import "Navigation.h"

#define kNearZero 0.000001f

@interface EAScrollNavigationBar () <UIGestureRecognizerDelegate>

//@property (strong) Navigation * navigation;
@property (strong, nonatomic) UIPanGestureRecognizer* panGesture;
@property (assign, nonatomic) CGFloat lastContentOffsetY;

@end

@implementation EAScrollNavigationBar

@synthesize scrollView = _scrollView,
scrollState = _scrollState,
panGesture = _panGesture,
lastContentOffsetY = _lastContentOffsetY;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handlePan:)];
    self.panGesture.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusBarOrientationDidChange)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidChangeStatusBarOrientationNotification
                                                  object:nil];
}

- (void)setScrollView:(UIScrollView*)scrollView
{
    _scrollView = scrollView;
    
    CGRect defaultFrame = self.frame;
    
    defaultFrame.origin.y = [self statusBarHeight];
    [self setFrame:defaultFrame alpha:1.0f animated:NO];
    
    // remove gesture from current panGesture's view
    if (self.panGesture.view) {
        [self.panGesture.view removeGestureRecognizer:self.panGesture];
    }
    
    if (scrollView) {
        [scrollView addGestureRecognizer:self.panGesture];
    }
}

- (void)resetToDefaultPosition:(BOOL)animated
{
    CGRect frame = self.frame;
    //frame.origin.y = [self statusBarHeight];
//    [self setFrame:frame alpha:1.0f animated:animated];
    
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options: UIViewAnimationOptionTransitionCurlDown
                     animations:^ {
                         self.frame = frame; }
                     completion:^(BOOL finished) {
                         [self setHidden:NO];
                     }];

    
//    if (!self.navigation)
//    {
//        self.navigation = [Navigation createNavigationView];
//        [self.navigation setUpMainNavigationButtons:FEED_PENDING];
//        
//        [self.navigation.leftBtn addTarget:self action:@selector(btnMenu:) forControlEvents:UIControlEventTouchUpInside];
//        [self.navigation.rightBtn addTarget:self action:@selector(btnAddEvent:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:self.navigation];
//    }
}

#pragma mark - notifications
- (void)statusBarOrientationDidChange
{
    //[self resetToDefaultPosition:NO];
}

- (void)applicationDidBecomeActive
{
    //[self resetToDefaultPosition:NO];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - panGesture handler
- (void)handlePan:(UIPanGestureRecognizer*)gesture
{
//    if (!self.scrollView || gesture.view != self.scrollView) {
//        return;
//    }
//    
//    if (self.scrollView.frame.size.height + (self.bounds.size.height * 2) >= self.scrollView.contentSize.height) {
//        return;
//    }
    
    CGFloat contentOffsetY = self.scrollView.contentOffset.y;
    
//    if (contentOffsetY < -self.scrollView.contentInset.top) {
//        return;
//    }
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.scrollState = EAScrollNavigationBarNone;
        self.lastContentOffsetY = contentOffsetY;
        return;
    }
    
    CGFloat deltaY = contentOffsetY - self.lastContentOffsetY;
    if (deltaY < 0.0f) {
        self.scrollState = EAScrollNavigationBarScrollingDown;
    } else if (deltaY > 0.0f) {
        self.scrollState = EAScrollNavigationBarScrollingUp;
    }
    
    CGRect frame = self.frame;
    CGFloat alpha = 1.0f;
//    CGFloat statusBarHeight = [self statusBarHeight];
    CGFloat statusBarHeight = 0;
    CGFloat maxY = statusBarHeight;
    CGFloat minY = maxY - CGRectGetHeight(frame) + 1.0f;
    // NOTE: plus 1px to prevent the navigation bar disappears in iOS < 7
    
    bool isScrollingAndGestureEnded = (gesture.state == UIGestureRecognizerStateEnded ||
                                       gesture.state == UIGestureRecognizerStateCancelled) &&
    (self.scrollState == EAScrollNavigationBarScrollingUp ||
     self.scrollState == EAScrollNavigationBarScrollingDown);
    
    NSLog(@"*** %u",self.scrollState);
    
    if (isScrollingAndGestureEnded) {
        CGFloat contentOffsetYDelta = 0.0f;
        if (self.scrollState == EAScrollNavigationBarScrollingDown) {
            contentOffsetYDelta = maxY - frame.origin.y;
            frame.origin.y = maxY;
            alpha = 1.0f;
            
            [UIView animateWithDuration:0.1
                                  delay:0.0
                                options: UIViewAnimationOptionTransitionCurlDown
                             animations:^ {
                                 self.frame = frame; }
                             completion:^(BOOL finished) {
                                 [self setHidden:NO];
                             }];

        }
        else if (self.scrollState == EAScrollNavigationBarScrollingUp) {
            contentOffsetYDelta = minY - frame.origin.y;
            frame.origin.y = minY;
            alpha = kNearZero;
            
            [UIView animateWithDuration:0.1
                                  delay:0.0
                                options: UIViewAnimationOptionTransitionCurlUp
                             animations:^ {
                                 self.frame = frame; }
                             completion:^(BOOL finished) {
                                 
                                 [self setHidden:YES];
                             }];
        }
        else {
            [UIView animateWithDuration:0.1
                                  delay:0.0
                                options: UIViewAnimationOptionTransitionNone
                             animations:^ {
                                 self.frame = frame; }
                             completion:^(BOOL finished) {
                                 [self setHidden:YES];
                             }];
        }
        if (!self.scrollView.decelerating) {
            CGPoint newContentOffset = CGPointMake(self.scrollView.contentOffset.x,
                                                   contentOffsetY - contentOffsetYDelta);
            [self.scrollView setContentOffset:newContentOffset animated:YES];
        }
    }
    else {
        frame.origin.y -= deltaY;
        frame.origin.y = MIN(maxY, MAX(frame.origin.y, minY));
        
        alpha = (frame.origin.y - (minY + statusBarHeight)) / (maxY - (minY + statusBarHeight));
        alpha = MAX(kNearZero, alpha);
        
        if (self.scrollState == EAScrollNavigationBarScrollingDown) {
            [UIView animateWithDuration:0.0
                                  delay:0.0
                                options: UIViewAnimationOptionTransitionCurlDown
                             animations:^ {
                                 self.frame = frame; }
                             completion:^(BOOL finished) {
                                 [self setHidden:NO];
                             }];
        }
        
        else if (self.scrollState == EAScrollNavigationBarScrollingUp) {
            [UIView animateWithDuration:0.0
                                  delay:0.0
                                options: UIViewAnimationOptionTransitionCurlDown
                             animations:^ {
                                 self.frame = frame; }
                             completion:^(BOOL finished) {
                                 [self setHidden:YES];
                             }];
        }
    }
    self.lastContentOffsetY = contentOffsetY;
}

#pragma mark - helper methods
- (CGFloat)statusBarHeight
{
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            return CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            return CGRectGetWidth([UIApplication sharedApplication].statusBarFrame);
        default:
            break;
    };
    return 0.0f;
}

- (void)setFrame:(CGRect)frame alpha:(CGFloat)alpha animated:(BOOL)animated
{
    if (animated) {
        [UIView beginAnimations:@"GTScrollNavigationBarAnimation" context:nil];
    }
    
    CGFloat offsetY = CGRectGetMinY(frame) - CGRectGetMinY(self.frame);
    
    for (UIView* view in self.subviews) {
        bool isBackgroundView = view == [self.subviews objectAtIndex:0];
        bool isViewHidden = view.hidden || view.alpha == 0.0f;
        if (isBackgroundView || isViewHidden)
            continue;
        view.alpha = alpha;
    }
    self.frame = frame;
    
    CGRect parentViewFrame = self.scrollView.superview.frame;
    parentViewFrame.origin.y += offsetY;
    parentViewFrame.size.height -= offsetY;
    self.scrollView.superview.frame = parentViewFrame;
    
    if (animated) {
        [UIView commitAnimations];
    }
}

@end

@implementation UINavigationController (EAScrollNavigationBarAdditions)

@dynamic scrollNavigationBar;

- (EAScrollNavigationBar*)scrollNavigationBar
{
    return (EAScrollNavigationBar*)self.navigationBar;
}


@end
