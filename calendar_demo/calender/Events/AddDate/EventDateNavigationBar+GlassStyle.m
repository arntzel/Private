//
//  EventDateNavigationBar.m
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDateNavigationBar+GlassStyle.h"
#import "DKLiveBlurView.h"

@implementation EventDateNavigationBar(GlassStyle)

- (void)setGlassImage:(UIImage *)image
{
    DKLiveBlurView *blurView = [[DKLiveBlurView alloc] initWithFrame:self.bgView.frame];
    blurView.isGlassEffectOn = YES;
    [blurView setBlurLevel:kDKBlurredBackgroundDefaultGlassLevel];
    [self.bgView removeFromSuperview];
    blurView.originalImage = image;
    self.bgView = blurView;
    [self insertSubview:self.bgView atIndex:0];
}

@end
