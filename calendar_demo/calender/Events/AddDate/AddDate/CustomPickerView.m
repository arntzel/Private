
#import "CustomPickerView.h"
#import "CustomPickerCell.h"

@implementation CustomPickerView
{
    UIView *maskView;
    
    UITableView *tableView;
    CGRect _selectionRect;
}


@synthesize delegate;


- (id)initWithFrame:(CGRect)frame Delegate:(id <CustomPickerViewDelegate>)_delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = _delegate;
        [self createContentTableView];
    }
    return self;
}

- (void)layoutSubviews {
    if (tableView == nil) {
        
    }
    [super layoutSubviews];
}

- (void)createContentTableView {

    tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];    
//    tableView.backgroundColor = [UIColor colorWithRed:252/255.0f green:252/255.0f blue:252/255.0f alpha:1.0f];
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;


    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;

    [self addSubview:tableView];
    [tableView reloadData];
    
    _selectionRect = CGRectMake(0, 0, self.bounds.size.width, 39);
    maskView = [[UIView alloc] initWithFrame:_selectionRect];
    [maskView setBackgroundColor:[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:0.7f]];
    [self addSubview:maskView];
    [maskView setAlpha:0.7f];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 39;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = [self.delegate numberOfRowsInSelector:self];
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    static BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"CustomPickerCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        nibsRegistered = YES;
    }
    
    
    CustomPickerCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSString *valueString = [NSString stringWithFormat:@"%d",indexPath.row];
    cell.labValue.text = valueString;
    cell.labUnit.text = @"minites";
    [cell initUI];
    
    return cell;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [self.delegate selector:self didSelectRowAtIndex:indexPath.row];
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
    CGRect selectionRectConverted = [self convertRect:_selectionRect toView:tableView];        
    NSArray *indexPathArray = [tableView indexPathsForRowsInRect:selectionRectConverted];
    
    CGFloat intersectionHeight = 0.0;
    NSIndexPath *selectedIndexPath = nil;
    
    for (NSIndexPath *index in indexPathArray) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:index];
        CGRect intersectedRect = CGRectIntersection(cell.frame, selectionRectConverted);
      
        if (intersectedRect.size.height>=intersectionHeight) {
            selectedIndexPath = index;
            intersectionHeight = intersectedRect.size.height;
        }
    }
    if (selectedIndexPath!=nil) {
        [tableView scrollToRowAtIndexPath:selectedIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [self.delegate selector:self didSelectRowAtIndex:selectedIndexPath.row];
    }
}



- (void)reloadData {
    [tableView reloadData];
}




@end
