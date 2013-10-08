//
//  UIView+LoadFromNib.m
//  Calvin
//
//  Created by tu changwei on 13-9-25.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "UIView+LoadFromNib.h"

@implementation UIView (LoadFromNib)

+ (id)tt_viewFromNibNamed:(NSString *)nibName owner:(id)ownerOrNil
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibName owner:ownerOrNil options:nil];
    for (id object in nib)
    {
        if ([object isKindOfClass:[self class]])
            return object;
    }
    return nil;
}

@end
