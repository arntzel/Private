//
//  LoginMainTitileView.m
//  login
//
//  Created by zyax86 on 9/23/13.
//  Copyright (c) 2013 zyax86. All rights reserved.
//

#import "LoginMainTitileView.h"

@implementation LoginMainTitileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)updateUI
{

}

+(LoginMainTitileView *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"LoginMainTitileView" owner:self options:nil];
    LoginMainTitileView * view = (LoginMainTitileView*)[nibView objectAtIndex:0];
    [view updateUI];
    
    return view;
}

@end
