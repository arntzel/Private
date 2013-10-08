//
//  UIImage+CirCle.m
//  Calvin
//
//  Created by tu changwei on 13-9-28.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "UIImage+CirCle.h"

@implementation UIImage (CirCle)

- (UIImage*)circleImage:(CGRect)rect
{
    UIGraphicsBeginImageContext(self.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [self drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

@end
