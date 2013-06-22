//
//  AddEventView.m
//  eventProj2
//
//  Created by zyax86 on 13-6-18.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "AddEventView.h"

@implementation AddEventView

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (void)initAppearenceAfterLoad
{
    [self.viewEventPhoto setContentMode:UIViewContentModeScaleAspectFill];
}
@end
