
#import "PickerView.h"
#import "CustomPickerCell.h"

@interface PickerView()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *maskView;
    
    UITableView *tableView;
    CGRect maskViewRect;
    
    NSInteger cellHeight;
    NSInteger numberOfData;
    NSInteger maxRepeatDataNumber;
}

@end

@implementation PickerView
@synthesize delegate;
@synthesize repeatEnable;
@synthesize UnitString;

- (void)dealloc
{
    [maskView release];
    [tableView release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        repeatEnable = NO;
        cellHeight = 40;
        numberOfData = 0;
        maxRepeatDataNumber = 65536;
        
        [self createContentTableView];
    }
    return self;
}

- (void)createContentTableView {
    tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];    
    tableView.backgroundColor = [UIColor colorWithRed:252/255.0f green:252/255.0f blue:252/255.0f alpha:1.0f];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    [self addSubview:tableView];
    
    maskViewRect = CGRectMake(0, 0, self.bounds.size.width, cellHeight);
    maskView = [[UIView alloc] initWithFrame:maskViewRect];
    [maskView setBackgroundColor:[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:0.7f]];
    [maskView setCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)];
    [self addSubview:maskView];
    [maskView setAlpha:0.7f];
    [maskView setUserInteractionEnabled:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)scrollToIndex:(NSInteger)index WithAnimation:(BOOL)animation
{
    if (repeatEnable)
    {
        NSInteger indexTo = (maxRepeatDataNumber / numberOfData) / 2 * numberOfData + index;
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexTo inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:animation];
    }
    else
    {
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:animation];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    numberOfData = [self.delegate numberOfRowsInPicker:self];
    if (repeatEnable) {
        return maxRepeatDataNumber;
    }
    else
    {
        return numberOfData;
    }
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";

    CustomPickerCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CustomPickerCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSInteger minute = indexPath.row % numberOfData;
    NSString *valueString = [NSString stringWithFormat:@"%d",minute];
    cell.labValue.text = valueString;
    cell.labUnit.text = UnitString;
    
    CGFloat width = tableView.frame.size.width;
    CGRect labelFrame = cell.frame;
    labelFrame.size.width = width;
    cell.frame = labelFrame;
    
    [cell initUI];
    [cell setBackgroundColor:[UIColor blackColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    NSInteger index = indexPath.row % numberOfData;
    [self.delegate selector:self didSelectRowAtIndex:index];
}

#pragma mark Scroll view methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollToTheSelectedCell];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollToTheSelectedCell];
    }
}

- (void)scrollToTheSelectedCell {
    CGRect selectionRectConverted = [self convertRect:maskViewRect toView:tableView];        
    NSArray *indexPathArray = [tableView indexPathsForRowsInRect:selectionRectConverted];
    
    CGFloat intersectionHeight = 0;
    NSIndexPath *selectedIndexPath = nil;
    
    for (NSIndexPath *index in indexPathArray) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:index];
        CGRect intersectedRect = CGRectIntersection(cell.frame, selectionRectConverted);
        if (intersectedRect.size.height >= intersectionHeight) {
            
            selectedIndexPath = index;
            intersectionHeight = intersectedRect.size.height;
        }
    }

    if (selectedIndexPath!=nil) {
        NSIndexPath *finalSelect = [NSIndexPath indexPathForRow:selectedIndexPath.row + 1 inSection:selectedIndexPath.section];
        [tableView scrollToRowAtIndexPath:finalSelect atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
        NSInteger index = finalSelect.row % numberOfData;
        [self.delegate selector:self didSelectRowAtIndex:index];
    }
}

- (void)reloadData {
    [tableView reloadData];
}




@end
