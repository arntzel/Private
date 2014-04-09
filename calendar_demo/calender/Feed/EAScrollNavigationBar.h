//
//  EAScrollNavigationBar.h
//  Calvin
//
//  Created by Eliot Arntz on 4/2/14.
//  Copyright (c) 2014 Pencil Me, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    EAScrollNavigationBarNone,
    EAScrollNavigationBarScrollingDown,
    EAScrollNavigationBarScrollingUp
} EAScrollNavigationBarState;

@protocol EAScrollNavigationbarDelegate <NSObject>

@optional
-(void)hideNavBar;
-(void)showNavBar;

@end

@interface EAScrollNavigationBar : UINavigationBar

@property (strong, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) EAScrollNavigationBarState scrollState;

- (void)resetToDefaultPosition:(BOOL)animated;

@end

@interface UINavigationController (EAScrollNavigationBarAdditions)

@property(strong, nonatomic, readonly) EAScrollNavigationBar *scrollNavigationBar;

@end
