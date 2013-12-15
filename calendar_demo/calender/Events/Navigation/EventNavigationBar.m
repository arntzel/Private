//
//  EventDateNavigationBar.m
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventNavigationBar.h"

@interface EventNavigationBar()

@property (retain, nonatomic) IBOutlet UIButton *leftBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end


@implementation EventNavigationBar
@synthesize delegate;

- (IBAction)leftBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(leftBtnPress:)]) {
        [self.delegate leftBtnPress:sender];
    }
}

- (void)awakeFromNib
{
    [self setBackgroundColor:[UIColor clearColor]];
    [self.bgView setBackgroundColor:[UIColor clearColor]];
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

+(EventNavigationBar *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventNavigationBar" owner:self options:nil];
    EventNavigationBar * view = (EventNavigationBar*)[nibView objectAtIndex:0];
    
    return view;
}

@end
