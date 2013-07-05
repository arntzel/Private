//
//  PickerView.m
//  AddDate
//
//  Created by zyax86 on 13-7-3.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "PickerView.h"
#import "CustomPickerCell.h"

#define CellHeight 40

@interface PickerView()<UIScrollViewDelegate>
{
    NSInteger rowNumber;
    UIScrollView *scrollView;
    NSMutableArray *itemArray;
}
@end

@implementation PickerView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        rowNumber = 1;
        
        itemArray = [[NSMutableArray alloc] init];
        
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
    [itemArray release];
    
    [super dealloc];
}

- (void)scrollToIndex:(NSInteger)index WithAnimation:(BOOL)animation
{
    
}

- (void)reloadData
{
    rowNumber = [self.delegate numberOfRowsInPicker:self];
    
    for (UIView *view in itemArray)
    {
        [view removeFromSuperview];
    }
    [itemArray removeAllObjects];
    
    CGFloat offsetY = (self.bounds.size.height - CellHeight) / 2;
    CGRect frame = CGRectMake(0, offsetY, self.bounds.size.width, CellHeight);
    for (NSInteger index = 0; index < rowNumber; index++) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CustomPickerCell" owner:self options:nil];
        CustomPickerCell *cell = (CustomPickerCell *)[nib objectAtIndex:0];
        [itemArray addObject:cell];
        frame.origin.y += CellHeight;
        [scrollView addSubview:cell];
        [cell setFrame:frame];
        
        cell.labValue.text = [NSString stringWithFormat:@"%d",index];
        cell.labUnit.text = @"min";
        
        [cell initUI];
    }
    
    [scrollView setContentSize:CGSizeMake(self.bounds.size.width, CellHeight * rowNumber + offsetY * 2)];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollToTheSelectedCell];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self scrollToTheSelectedCell];
    }
}

- (void)scrollToTheSelectedCell
{
    [self.delegate Picker:self didSelectRowAtIndex:1];
}
@end
