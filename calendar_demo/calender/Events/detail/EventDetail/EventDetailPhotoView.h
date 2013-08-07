//
//  EventDetailPhotoView.h
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKLiveBlurView.h"

@interface EventDetailPhotoView : UIView
@property (retain, nonatomic) IBOutlet DKLiveBlurView *photoView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;

- (void)setImage:(UIImage *)image;

- (void)setScrollView:(UIScrollView *)_scrollView;
- (void)setNavgation:(UIView *)navigation;

+ (EventDetailPhotoView *) creatView;


@end