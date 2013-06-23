
#import "CustomPickerView.h"
#import <QuartzCore/QuartzCore.h>


@implementation CustomPickerView
{
    UITableView *tableView;
    CGRect _selectionRect;
}


@synthesize delegate;


- (id)initWithDelegate:(id <CustomPickerViewDelegate>)_delegate
{
    self = [super initWithFrame:CGRectMake(100, 50, 120, 400)];
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

    if (self.debugEnabled) {
        tableView.layer.borderColor = [UIColor blueColor].CGColor;
        tableView.layer.borderWidth = 1.0;
        tableView.layer.cornerRadius = 10.0;
    
        tableView.tableHeaderView.layer.borderColor = [UIColor blackColor].CGColor;
        tableView.tableFooterView.layer.borderColor = [UIColor blackColor].CGColor;
    }
    
    tableView.backgroundColor = [UIColor greenColor];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;


    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;

    [self addSubview:tableView];
    [tableView reloadData];
    
    
    UIImageView *selectionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selectorRect.png"]];
    _selectionRect = CGRectMake(0, 210, self.bounds.size.width, 70);
    selectionImageView.frame = _selectionRect;
    [self addSubview:selectionImageView];
    [selectionImageView setAlpha:0.7f];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
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
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *labelString = [NSString stringWithFormat:@"%d",indexPath.row];
    cell.textLabel.text = labelString;
    
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
        //looping through the closest cells to get the closest one
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:index];
        CGRect intersectedRect = CGRectIntersection(cell.frame, selectionRectConverted);
      
        if (intersectedRect.size.height>=intersectionHeight) {
            selectedIndexPath = index;
            intersectionHeight = intersectedRect.size.height;
        }
    }
    if (selectedIndexPath!=nil) {
        //As soon as we elected an indexpath we just have to scroll to it
        [tableView scrollToRowAtIndexPath:selectedIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [self.delegate selector:self didSelectRowAtIndex:selectedIndexPath.row];
    }
}



- (void)reloadData {
    [tableView reloadData];
}




@end
