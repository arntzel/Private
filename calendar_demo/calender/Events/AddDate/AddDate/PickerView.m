//
//  PickerView.m
//  AddDate
//
//  Created by zyax86 on 13-7-3.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "PickerView.h"

@interface PickerView()<UIScrollViewDelegate>
{
    CGFloat heightPerRow;
    NSInteger allRowNumber;
    NSInteger effectRowNumber;
    
    UIScrollView *scrollView;
}
@end

@implementation PickerView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        heightPerRow = 1.0f;
        allRowNumber = 1;
        effectRowNumber = 1;
        
        scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:scrollView];
        [scrollView setBounces:YES];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [scrollView setBackgroundColor:[UIColor clearColor]];
        [scrollView setDelegate:self];
    }
    return self;
}

- (void)dealloc
{
    [scrollView release];
    [super dealloc];
}

- (void)scrollToIndex:(NSInteger)index WithAnimation:(BOOL)animation
{
    
}

- (void)reloadData
{
    heightPerRow = [self.delegate heightPerRowInPicker:self];
    effectRowNumber = [self.delegate numberOfRowsInPicker:self];
    NSInteger noEffectRowNumber = ceil(self.bounds.size.height / heightPerRow);
    allRowNumber = effectRowNumber + noEffectRowNumber - 1;
}
@end
