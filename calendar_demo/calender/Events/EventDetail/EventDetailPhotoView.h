//
//  EventDetailPhotoView.h
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKLiveBlurView.h"

@protocol EventDetailPhotoViewDelegate <NSObject>

- (void)detailPhotoDidChanged:(UIImage *)image;

@end

@interface EventDetailPhotoView : UIView
@property (retain, nonatomic) DKLiveBlurView *photoView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (assign, nonatomic) UIViewController<EventDetailPhotoViewDelegate> *controller;

- (void)setDefaultImage;
- (void)addCreatorAction;

- (void)setImage:(UIImage *)image;
- (void)setImageUrl:(NSString *) imageUrl;

- (void)setScrollView:(UIScrollView *)_scrollView;
- (void)setNavgation:(UIView *)navigation;

+ (EventDetailPhotoView *) creatView;


@end
