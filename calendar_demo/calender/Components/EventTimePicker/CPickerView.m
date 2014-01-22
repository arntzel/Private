#import "CPickerView.h"
#import "CPickerCell.h"

@interface CPickerView()<UIScrollViewDelegate>
{
    NSInteger rowNumber;
    UIScrollView *scrollView;
    NSMutableArray *itemArray;
    UIView *maskView;
    
    CGFloat offsetY;
    
    NSInteger selectedIndex;
}
@end

@implementation CPickerView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:225/255.0f green:225/255.0f blue:225/255.0f alpha:1.0f]];
        rowNumber = 1;
        itemArray = [[NSMutableArray alloc] init];
        
        maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 40)];
        [maskView setBackgroundColor:[UIColor colorWithRed:202/255.0f green:210/255.0f blue:207/255.0f alpha:1.0f]];
        [maskView setCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)];
        [maskView setUserInteractionEnabled:NO];
        [self addSubview:maskView];
        
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
    scrollView.delegate = nil;
}

- (void)scrollToIndex:(NSInteger)index WithAnimation:(BOOL)animation
{
    [self deMaskSelectedCell];
    selectedIndex = index;
    [self maskSelectedCell];
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
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CPickerCell" owner:self options:nil];
        CPickerCell *cell = (CPickerCell *)[nib objectAtIndex:0];
        [itemArray addObject:cell];
        frame.origin.y = offsetY + CellHeight * index;
        frame.size.width = self.frame.size.width;
        [scrollView addSubview:cell];
        [cell setFrame:frame];
        cell.label.text = [self.delegate stringOfRowsInPicker:self AtIndex:index];
        
        [cell initUI];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    [self maskSelectedCell];
    
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self deMaskSelectedCell];
}

- (void)scrollToTheSelectedCell
{
    CGFloat yOffset = scrollView.contentOffset.y;
    
    NSInteger remainder = ((NSInteger)yOffset) % CellHeight;
    selectedIndex = yOffset / CellHeight;
    if (remainder > CellHeight / 2) {
        selectedIndex++;
    }
    
    [self maskSelectedCell];
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [scrollView setContentOffset:CGPointMake(0, CellHeight * selectedIndex)];
    } completion:^(BOOL finished) {
        [self.delegate Picker:self didSelectRowAtIndex:selectedIndex];
    }];
}

- (void)maskSelectedCell
{
    CPickerCell *cell = (CPickerCell *)[itemArray objectAtIndex:selectedIndex];
    [cell setMasked:YES];
}

- (void)deMaskSelectedCell
{
    CPickerCell *cell = (CPickerCell *)[itemArray objectAtIndex:selectedIndex];
    [cell setMasked:NO];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    for (NSInteger index = 0; index < [itemArray count]; index++) {
        CPickerCell *cell = [itemArray objectAtIndex:index];
        [cell setTextAlignment:textAlignment];
    }
}

- (void)setTextHidden:(Boolean)hidden
{
    for (NSInteger index = 0; index < [itemArray count]; index++) {
        CPickerCell *cell = [itemArray objectAtIndex:index];
        [cell.label setHidden:hidden];
    }
}

@end
