//
//  EventDetailPhotoView.m
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDetailPhotoView.h"


@implementation EventDetailPhotoView
{
    UIView *navBar;
    UIScrollView *scrollView;
}

- (void)updateUI
{
    DKLiveBlurView *blurView = [[DKLiveBlurView alloc] initWithFrame:self.photoView.frame];
    blurView.isGlassEffectOn = YES;
    [_photoView removeFromSuperview];
    [_photoView release];
    
    self.photoView = blurView;
    [self insertSubview:blurView belowSubview:_titleLabel];
}

- (void)setImage:(UIImage *)image
{
    [self.photoView setOriginalImage:image];
}

- (void)setScrollView:(UIScrollView *)_scrollView
{
    [scrollView removeObserver:self forKeyPath: @"contentOffset"];
    
    scrollView = nil;
    scrollView = _scrollView;
    self.photoView.scrollView = _scrollView;
    
    if (scrollView)
    {
        [scrollView addObserver:self forKeyPath: @"contentOffset" options: 0 context: nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context{
    if (!navBar) {
        return;
    }
    
    CGFloat scrollOffsetY = scrollView.contentOffset.y;
    CGFloat scrollScope = self.frame.size.height - navBar.frame.size.height;
    if (scrollOffsetY > scrollScope) {
        scrollOffsetY = scrollScope;
    }
    
    [self.titleLabel setCenter:CGPointMake(self.titleLabel.center.x, navBar.frame.size.height / 2 + (scrollScope - scrollOffsetY))];
    
    CGFloat maxFont = 20;
    CGFloat minFont = 13;
    
    CGFloat fontRadio = 1 - (scrollScope - scrollOffsetY) / scrollScope;
    
    CGFloat currentFont = maxFont - (maxFont - minFont) * fontRadio;
    
    [self.titleLabel setFont:[UIFont systemFontOfSize:currentFont]];
}

- (void)setNavgation:(UIView *)navigation
{
    navBar = nil;
    navBar = navigation;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    [_photoView release];
    [_titleLabel release];
    [super dealloc];
}


+(EventDetailPhotoView *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventDetailPhotoView" owner:self options:nil];
    EventDetailPhotoView * view = (EventDetailPhotoView*)[nibView objectAtIndex:0];
    [view updateUI];
    
    return view;
}

@end
