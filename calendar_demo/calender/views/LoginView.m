//
//  LoginView.m
//  calender
//
//  Created by fang xiang on 13-6-8.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(LoginView *) createView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:self options:nil];
    LoginView * view = (LoginView*)[nibView objectAtIndex:0];
    return view;
}

@end
