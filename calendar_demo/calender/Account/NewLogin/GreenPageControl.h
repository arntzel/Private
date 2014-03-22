//
//  GreenPageControl.h
//  Calvin
//
//  Created by Kevin Wu on 3/22/14.
//  Copyright (c) 2014 Pencil Me, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GreenPageControlDelegate <NSObject>

@required
- (void)pageControlDidStopAtIndex:(NSInteger)index;

@end

@interface GreenPageControl : UIView
{
    UIImage         *_normalDotImage;
    UIImage         *_highlightedDotImage;
    NSInteger       __pageNumbers;
    float           __dotsSize;
    NSInteger       __dotsGap;
    __unsafe_unretained id<GreenPageControlDelegate> delegate;
}

@property (nonatomic , assign)id<GreenPageControlDelegate> delegate;

- (id)initWithFrame:(CGRect)frame normalImage:(UIImage *)nImage highlightedImage:(UIImage *)hImage dotsNumber:(NSInteger)pageNum sideLength:(NSInteger)size dotsGap:(NSInteger)gap;

- (void)setCurrentPage:(NSInteger)pages;

@end