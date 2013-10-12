//
//  ExtendTextField.m
//  Calvin
//
//  Created by zyax86 on 10/12/13.
//  Copyright (c) 2013 fang xiang. All rights reserved.
//

#import "ExtendTextField.h"

@implementation ExtendTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) drawPlaceholderInRect:(CGRect)rect {
    [[UIColor grayColor] setFill];
    [self.placeholder drawInRect:rect withFont:self.font lineBreakMode:NSLineBreakByTruncatingTail alignment:self.textAlignment];
}

@end
