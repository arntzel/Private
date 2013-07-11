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
    UIView *maskView;
    
    CGFloat offsetY;
    
    NSInteger selectedIndex;
}
@end

@implementation PickerView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:252.0/255.0f green:252.0/255.0f blue:252.0/255.0f alpha:1.0f]];
        
        rowNumber = 1;
        
        itemArray = [[NSMutableArray alloc] init];
        
        scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:scrollView];
        [scrollView setBounces:YES];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [scrollView setBackgroundColor:[UIColor clearColor]];
        [scrollView setDelegate:self];

        maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 40)];
        [maskView setBackgroundColor:[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:0.7f]];
        [maskView setCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)];
        [maskView setUserInteractionEnabled:NO];
        [self addSubview:maskView];
    }
    return self;
}

- (void)dealloc
{
    scrollView.delegate = nil;
    [scrollView release];
    [itemArray release];
    [maskView release];
    
    [super dealloc];
}

- (void)scrollToIndex:(NSInteger)index WithAnimation:(BOOL)animation
{
    selectedIndex = index;
    [scrollView setContentOffset:CGPointMake(0, CellHeight * selectedIndex) animated:YES];
}

- (void)reloadData
{
    rowNumber = [self.delegate numberOfRowsInPicker:self];
    
    for (UIView *view in itemArray)
    {
        [view removeFromSuperview];
    }
    [itemArray removeAllObjects];
    
    offsetY = (self.bounds.size.height - CellHeight) / 2;
    CGRect frame = CGRectMake(0, offsetY, self.bounds.size.width, CellHeight);
    for (NSInteger index = 0; index < rowNumber; index++) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CustomPickerCell" owner:self options:nil];
        CustomPickerCell *cell = (CustomPickerCell *)[nib objectAtIndex:0];
        [itemArray addObject:cell];
        frame.origin.y = offsetY + CellHeight * index;
        [scrollView addSubview:cell];
        [cell setFrame:frame];
        [cell setLabelWidth:75];
        cell.labValue.text = [self.delegate stringOfRowsInPicker:self AtIndex:index];
        
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
    CGFloat yOffset = scrollView.contentOffset.y;
    
    NSInteger remainder = ((NSInteger)yOffset) % CellHeight;
    selectedIndex = yOffset / CellHeight;
    if (remainder > CellHeight / 2) {
        selectedIndex++;
    }
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [scrollView setContentOffset:CGPointMake(0, CellHeight * selectedIndex)];
    } completion:^(BOOL finished) {
        [self.delegate Picker:self didSelectRowAtIndex:selectedIndex];
    }];
}

@end
