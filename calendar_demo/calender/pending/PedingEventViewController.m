

#import "PedingEventViewController.h"
#import "Navigation.h"
#import "EventPendingToolbar.h"
#import "PendingEventViewCell.h"

#import "RootNavContrller.h"

@interface PedingEventViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation PedingEventViewController {
    Navigation * navigation;
    EventPendingToolbar * toolbar;
    UITableView * table1;
    UITableView * table2;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    navigation = [Navigation createNavigationView];
    navigation.titleLable.text = @"PENDING";
    [self.view addSubview:navigation];

    [navigation.leftBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];

    int y = navigation.frame.size.height;
    toolbar = [EventPendingToolbar createView];

    [toolbar.segmentedControl addTarget:self action:@selector(tableChange:) forControlEvents:UIControlEventValueChanged];

    CGRect frame = self.view.bounds;
    frame.origin.y = y;
    toolbar.frame = frame;
    [self.view addSubview:toolbar];

    y += toolbar.frame.origin.y;

    
    frame = self.view.bounds;
    frame.origin.y = y;
    frame.size.height -= y;

    table1 = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    //table1.backgroundColor = [UIColor blueColor];
    table1.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [table1 setAllowsSelection:NO];
    table1.dataSource = self;
    table1.delegate = self;
    [self.view addSubview:table1];

    table2 = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    //table2.backgroundColor = [UIColor redColor];
    table2.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [table2 setAllowsSelection:NO];
    table2.dataSource = self;
    table2.delegate = self;
    [self.view addSubview:table2];
}


-(void)back:(id)sender {
    [[RootNavContrller defaultInstance] popViewControllerAnimated:YES];
}

-(void)tableChange:(id)sender{

    UISegmentedControl* control = (UISegmentedControl*)sender;

    if(control.selectedSegmentIndex == 0) {
        table1.hidden = NO;
        table2.hidden = YES;
    } else {
        table1.hidden = YES;
        table2.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PendingEventViewCell * cell = [PendingEventViewCell createView];



    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    if(section == 0) {
        return nil;
    }

    NSString * title;
    if(tableView == table1) {
       title = @"WAITING FOR FINALIZATION";
    } else {
        title = @"WAITING FOR RESPONSES";
    }

    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 24)];
    header.backgroundColor = [UIColor grayColor];
    UILabel * label = [[UILabel alloc] initWithFrame:header.frame];
    label.backgroundColor = [UIColor clearColor];
    label.text = title;

    [header addSubview:label];
    return header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    } else {
        return 24;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        return 80;
    } else {
        return 80;
    }
}



@end
