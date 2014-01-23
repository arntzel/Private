//
//  grayNavgationBar.m
//  test
//
//  Created by zyax86 on 13-7-7.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "NavgationBar.h"

@interface NavgationBar()
{
    UILabel *labelTitle;
    
    UIButton *leftBtn;
    UIButton *rightBtn;
}

@end

@implementation NavgationBar
@synthesize delegate;

- (void)dealloc
{
    [labelTitle release];
    [leftBtn release];
    [rightBtn release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUserInteractionEnabled:YES];
        self.backgroundColor = [UIColor colorWithRed:45/255.0f green:172/255.0f blue:149/255.0f alpha:1.0f];
        //[self setImage:[UIImage imageNamed:@"navBar_bg.png"]];
        
        CGRect titleFrame = frame;
        titleFrame.origin.y += 20;
        titleFrame.size.height -= 20;
        
        labelTitle = [[UILabel alloc] initWithFrame:titleFrame];
        [labelTitle setBackgroundColor:[UIColor clearColor]];
        
        labelTitle.textAlignment = NSTextAlignmentCenter;
        //自动折行设置
        labelTitle.lineBreakMode = NSLineBreakByWordWrapping;
        labelTitle.numberOfLines = 0;
        
        [self addSubview:labelTitle];
        labelTitle.text = @"NEW EVENT";
        [labelTitle setTextAlignment:NSTextAlignmentCenter];
        [labelTitle setTextColor:[UIColor whiteColor]];
        [labelTitle setFont:[UIFont boldSystemFontOfSize:14]];
        
        leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 26, 32, 32)];
        leftBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [leftBtn setImage:[UIImage imageNamed:@"back_button_asset"] forState:UIControlStateNormal];
        [leftBtn setTitle:@"" forState:UIControlStateNormal];
        [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
        
        //[leftBtn setTitleColor:[UIColor colorWithRed:78.0f/255.0f green:78.0f/255.0f blue:78.0f/255.0f  alpha:1.0f] forState:UIControlStateNormal];
        [self addSubview:leftBtn];
        [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(264, 28, 51, 29)];
        //[rightBtn setBackgroundImage:[UIImage imageNamed:@"navBtn_bg.png"] forState:UIControlStateNormal];
        [rightBtn setTitle:@"Create" forState:UIControlStateNormal];
        [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
        //[rightBtn setTitleColor:[UIColor colorWithRed:78.0f/255.0f green:78.0f/255.0f blue:78.0f/255.0f  alpha:1.0f] forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:rightBtn];
        [rightBtn addTarget:self action:@selector(rightBtnCick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (id)init
{
    return [self initWithFrame:CGRectMake(0, 0, 320, 65)];
}

- (void)setTitle:(NSString *)title
{
    [labelTitle setText:title];
}

- (void)setLeftBtnText:(NSString *)text
{
    [leftBtn setTitle:text forState:UIControlStateNormal];
}

- (void)setRightBtnText:(NSString *)text
{
    [rightBtn setTitle:text forState:UIControlStateNormal];
}

- (void) setRightBtnHidden:(BOOL) hidden;
{
    rightBtn.hidden = hidden;
}

-(void) setRightBtnEnable:(BOOL) enable
{
    rightBtn.enabled = enable;
}

- (void)leftBtnClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(leftNavBtnClick)]) {
        [self.delegate leftNavBtnClick];
    }
}

- (void)rightBtnCick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(rightNavBtnClick)]) {
        [self.delegate rightNavBtnClick];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
