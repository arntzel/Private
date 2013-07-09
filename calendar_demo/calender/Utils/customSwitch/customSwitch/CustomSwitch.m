//
//  CustomSwitch.m
//  customSwitch
//
//  Created by zyax86 on 13-7-9.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "CustomSwitch.h"

#define padding 1

@interface CustomSwitch()
{
    UIImageView *bgView;
    UIButton *frontView;
    
    NSInteger segmentCount;
    
    NSMutableArray *titleArray;
    
    NSInteger selectedIndex;
    UILabel *heilightLabel;
    
    CGPoint diffPoint;
}

@end


@implementation CustomSwitch
@synthesize selectedIndex;

- (void)dealloc
{
    [bgView release];
    [frontView release];
    [titleArray release];
    [heilightLabel release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame segmentCount:(NSInteger)count
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        segmentCount = count;
        selectedIndex = 0;
        
        UIImage *imageBg = [UIImage imageNamed:@"customSwitchBg.png"];
        imageBg = [imageBg resizableImageWithCapInsets:UIEdgeInsetsMake(13, 38, 13, 38)];
        bgView = [[UIImageView alloc] initWithImage:imageBg];
        [self addSubview:bgView];
        [bgView setFrame:self.bounds];

        [self initbgLabel];
        [self initFrontView];
        
        
        UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ItemSelected:)];
        [self addGestureRecognizer:gest];
        [gest release];

    }
    return self;
}

- (void)initbgLabel
{
    titleArray = [[NSMutableArray alloc] init];
    CGRect bgLabelFrame = self.bounds;
    bgLabelFrame.origin.y = padding;
    bgLabelFrame.size.height -= (padding * 2);
    bgLabelFrame.origin.x = padding;
    bgLabelFrame.size.width = (self.bounds.size.width - padding * 2) / segmentCount;
                                 
                                 
    for (NSInteger index = 0; index < segmentCount; index++) {
        bgLabelFrame.origin.x = padding + bgLabelFrame.size.width * index;
        
        UILabel *label = [[UILabel alloc] initWithFrame:bgLabelFrame];
        [label setBackgroundColor:[UIColor clearColor]];
        [self addSubview:label];
        [label setText:[NSString stringWithFormat:@"%d",index]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor colorWithRed:116.0f/255.0f green:116.0f/255.0f blue:116.0f/255.0f alpha:0.85f]];
        [label setFont:[UIFont systemFontOfSize:15]];
        
        [titleArray addObject:label];
        [label release];
    }
}

- (void)initFrontView
{
    UIImage *imageFront = [UIImage imageNamed:@"customSwitchFront.png"];
    imageFront = [imageFront resizableImageWithCapInsets:UIEdgeInsetsMake(12, 16, 12, 16)];
    UIImageView *frontViewBg = [[UIImageView alloc] initWithImage:imageFront];
    
    
    CGRect frontViewFrame = self.bounds;
    frontViewFrame.origin.y = padding;
    frontViewFrame.size.height -= (padding * 2);
    frontViewFrame.origin.x = padding;
    frontViewFrame.size.width = (self.bounds.size.width - padding * 2) / segmentCount;
    
    frontView = [[UIButton alloc] initWithFrame:frontViewFrame];
    [frontViewBg setFrame:frontView.bounds];
    [frontView addSubview:frontViewBg];
    [frontViewBg release];
    [self addSubview:frontView];
    
    heilightLabel = [[UILabel alloc] initWithFrame:frontView.bounds];
    [self updateHeilightLabel];
    [heilightLabel setBackgroundColor:[UIColor clearColor]];
    [heilightLabel setTextAlignment:NSTextAlignmentCenter];
    [heilightLabel setTextColor:[UIColor colorWithRed:116.0f/255.0f green:116.0f/255.0f blue:116.0f/255.0f alpha:1.0f]];
    [heilightLabel setFont:[UIFont systemFontOfSize:15]];
    [frontView addSubview:heilightLabel];
    
    [frontView addTarget:self action:@selector(TouchDown:withEvent:) forControlEvents:UIControlEventTouchDown];
    [frontView addTarget:self action:@selector(TouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [frontView addTarget:self action:@selector(TouchMove:withEvent:) forControlEvents: UIControlEventTouchDragOutside | UIControlEventTouchDragInside];
}

- (void)updateHeilightLabel
{
    UILabel *selectLabel = [titleArray objectAtIndex:selectedIndex];
    [heilightLabel setText:selectLabel.text];
}

- (void)setSegTitle:(NSString *)title AtIndex:(NSInteger)index
{
    UILabel *selectLabel = [titleArray objectAtIndex:index];
    [selectLabel setText:title];
    [self updateHeilightLabel];
}


-(void) ItemSelected: (UITapGestureRecognizer *) tap {
    selectedIndex = [self getSelectedSlotInPoint:[tap locationInView:self]];
    [self switchToSelectedIndex:selectedIndex];
}

-(int)getSelectedSlotInPoint:(CGPoint)pnt{
    CGFloat  slotInPoint= (pnt.x - padding) / frontView.frame.size.width;
    NSInteger index = 0;
    if(slotInPoint < 0)
        index = 0;
    else
        index = slotInPoint;
    if (index >= segmentCount) {
        index = segmentCount - 1;
    }
    
    return index;
}

-(void) switchToSelectedIndex:(int)index{
    [self animateHandlerToIndex:index];
    
}

-(void) animateHandlerToIndex:(int) index{
    
    CGFloat startX = index * frontView.frame.size.width + padding;
    [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [frontView setFrame:CGRectMake(startX, frontView.frame.origin.y , frontView.frame.size.width, frontView.frame.size.height)];
        [self updateHeilightLabel];
    } completion:^(BOOL finished) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }];
}

- (void) TouchDown: (UIButton *) btn withEvent: (UIEvent *) ev{
    CGPoint currPoint = [[[ev allTouches] anyObject] locationInView:self];
    diffPoint = CGPointMake(currPoint.x - btn.center.x, currPoint.y - btn.center.y);
    [self sendActionsForControlEvents:UIControlEventTouchDown];
}

- (void) TouchMove: (UIButton *) btn withEvent: (UIEvent *) ev {
    CGPoint currPoint = [[[ev allTouches] anyObject] locationInView:self];
    
    CGPoint toPoint = CGPointMake(currPoint.x-diffPoint.x, frontView.center.y);
    
    if (toPoint.x < frontView.frame.size.width / 2) {
        toPoint.x = frontView.frame.size.width / 2;
    }
    else if(toPoint.x + frontView.frame.size.width / 2 > self.frame.size.width) {
        toPoint.x = self.frame.size.width - frontView.frame.size.width / 2;
    }
    
    [frontView setCenter:CGPointMake(toPoint.x, toPoint.y)];
    
    [self sendActionsForControlEvents:UIControlEventTouchDragInside];
}

-(void) TouchUp: (UIButton*) btn{
    
    selectedIndex = [self getSelectedSlotInPoint:btn.center];
    [self animateHandlerToIndex:selectedIndex];
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
