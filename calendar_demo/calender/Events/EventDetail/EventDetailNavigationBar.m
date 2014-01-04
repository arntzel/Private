//
//  EventDetailNavigationBar.m
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDetailNavigationBar.h"
#import "UIColor+Hex.h"

@implementation EventDetailNavigationBar
@synthesize delegate;

- (void)dealloc {
    [_leftBtn release];
    [_rightbtn release];
    [super dealloc];
}

- (IBAction)leftBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(leftBtnPress:)]) {
        [self.delegate leftBtnPress:sender];
    }
}

- (IBAction)rightBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(rightBtnPress:)]) {
        [self.delegate rightBtnPress:sender];
    }
}

+(EventDetailNavigationBar *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventDetailNavigationBar" owner:self options:nil];
    EventDetailNavigationBar * view = (EventDetailNavigationBar*)[nibView objectAtIndex:0];
    //view.backgroundColor = [UIColor generateUIColorByHexString:@"#18a48b"];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end
