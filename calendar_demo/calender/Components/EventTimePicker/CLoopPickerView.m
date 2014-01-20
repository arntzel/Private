
#import "CLoopPickerView.h"
#import "CPickerCell.h"
#import "EventTimePickerDefine.h"

@interface CLoopPickerView()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *maskView;
    
    UITableView *tableView;
    CGRect maskViewRect;
    NSInteger numberOfData;
    NSInteger maxRepeatDataNumber;
    
    NSTextAlignment cellAlignment;
    Boolean txtHidden;
}

@end

@implementation CLoopPickerView
@synthesize delegate;

- (void)dealloc
{
    tableView.delegate = nil;
    tableView.dataSource = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        numberOfData = 0;
        maxRepeatDataNumber = MAX_REPETA_DATA_NUMBER;
        cellAlignment = NSTextAlignmentLeft;
        txtHidden = false;
        
        [self createContentTableView];
    }
    return self;
}

- (void)createContentTableView {
    tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];    
    [tableView setBackgroundColor:[UIColor colorWithRed:225/255.0f green:225/255.0f blue:225/255.0f alpha:1.0f]];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    [self addSubview:tableView];
    
    maskViewRect = CGRectMake(0, 0, self.bounds.size.width, CellHeight);
    maskView = [[UIView alloc] initWithFrame:maskViewRect];
    [maskView setBackgroundColor:[UIColor colorWithRed:207/255.0f green:201/255.0f blue:206/255.0f alpha:0.7f]];
    [maskView setCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)];
    
    [self addSubview:maskView];
    [maskView setUserInteractionEnabled:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
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

    CPickerCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CPickerCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.label.text = [self.delegate stringOfRowsInPicker:self AtIndex:(indexPath.row % numberOfData)];
    
    CGFloat width = tableView.frame.size.width;
    CGRect labelFrame = cell.frame;
    labelFrame.size.width = width;
    cell.frame = labelFrame;

    [cell initUI];
    [cell setTextAlignment:cellAlignment];
    [cell.label setHidden:txtHidden];
    [cell.label setBackgroundColor:[UIColor clearColor]];
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

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    cellAlignment = textAlignment;
    [tableView reloadData];
}

- (void)setTextHidden:(Boolean)hidden
{
    txtHidden = hidden;
    [tableView reloadData];
}

@end
