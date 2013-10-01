//
//  SettingsContentView.m
//  Calvin
//
//  Created by tu changwei on 13-9-25.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "SettingsContentView.h"

@implementation SettingsContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)viewClicked:(id)sender
{
    UIView *view;
    if ([sender isKindOfClass:[UITapGestureRecognizer class]])
    {
        view = ((UITapGestureRecognizer *)sender).view;
    }
    else
    {
       view = (UIView *)sender;
    }
    NSLog(@"view tag %d", view.tag);
    
    if (self.pushDetailViewBlock)
    {
        self.pushDetailViewBlock(view.tag);
    }
}

@end
