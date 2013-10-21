
#import "LoopPickerView.h"
#import "CustomPickerCell.h"

@interface LoopPickerView()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *maskView;
    
    UITableView *tableView;
    CGRect maskViewRect;
    
    NSInteger cellHeight;
    NSInteger numberOfData;
    NSInteger maxRepeatDataNumber;
    
    UILabel *unitLabel;
    
    CGFloat unitOffset;
}

@end

@implementation LoopPickerView
@synthesize delegate;

- (void)dealloc
{
    [maskView release];
    tableView.delegate = nil;
    tableView.dataSource = nil;
    [tableView release];
    [unitLabel release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        cellHeight = 40;
        numberOfData = 0;
        maxRepeatDataNumber = 65536;
        unitOffset = 0;
        
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
    
    unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(maskView.frame.size.width / 2, maskView.frame.origin.y, maskView.frame.size.width, maskView.frame.size.height)];
    [unitLabel setBackgroundColor:[UIColor clearColor]];
    [unitLabel setTextColor:[UIColor colorWithRed:130/255.0f green:125/255.0f blue:125/255.0f alpha:1.0f]];
    [unitLabel setFont:[UIFont systemFontOfSize:22]];
    [unitLabel setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:unitLabel];
    
    [self addSubview:maskView];
    [maskView setAlpha:0.7f];
    [maskView setUserInteractionEnabled:NO];
}

- (void)setUnitString:(NSString *)UnitString
{
    unitLabel.text = UnitString;
    [self reloadData];
}

- (void)setUnitOffset:(CGFloat)offset
{
    unitOffset = offset;
    CGRect frame = unitLabel.frame;
    frame.origin.x = offset;
    frame.size.width = self.frame.size.width - offset;
    unitLabel.frame = frame;
    
    [self reloadData];
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
    NSInteger indexTo = (maxRepeatDataNumber / numberOfData) / 2 * numberOfData + index;
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexTo inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:animation];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    numberOfData = [self.delegate numberOfRowsInPicker:self];
    return maxRepeatDataNumber;

}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";

    CustomPickerCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CustomPickerCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
//    NSInteger value = indexPath.row % numberOfData;
    NSInteger value = [self.delegate integerOfRowsInPicker:self AtIndex:(indexPath.row % numberOfData)];
    NSString *valueString = [NSString stringWithFormat:@"%02d",value];

    cell.labValue.text = valueString;
    
    CGFloat width = tableView.frame.size.width;
    CGRect labelFrame = cell.frame;
    labelFrame.size.width = width;
    cell.frame = labelFrame;
    
    [cell setLabelWidth:unitOffset - 10];
    [cell initUI];
    
    return cell;
}

//- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//    NSInteger index = indexPath.row % numberOfData;
//    [self.delegate selector:self didSelectRowAtIndex:index];
//}

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
        [self.delegate Picker:self didSelectRowAtIndex:index];
    }
}

- (void)reloadData {
    [tableView reloadData];
}




@end
