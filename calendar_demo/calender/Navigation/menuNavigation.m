#import "menuNavigation.h"
#import "DDMenuController.h"

#import "navigationMenuCell.h"
#import "navigationNotifyCell.h"
#import "navigationNotifySectionHeader.h"

#import "navigationMenuDataSource.h"
#import "navigationNotifyDataSource.h"

@interface menuNavigation()<UITableViewDelegate,UITableViewDataSource>
{
    navigationMenuDataSource *menuDataSource;
    navigationNotifyDataSource *notifyDataSource;
}
@end


@implementation menuNavigation

@synthesize tableView=_tableView;


- (UIViewController*)localAlbumController
{    
    return nil;
}
- (UIViewController*)cloudAlbumController
{
    return nil;
}

- (id)init {
    if ((self = [super init])) {
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    menuDataSource = [[navigationMenuDataSource alloc] init];
    notifyDataSource = [[navigationNotifyDataSource alloc] init];
    
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.bounces = NO;
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        tableView.dataSource = self;
        tableView.delegate = self;
        
        
        [self.view addSubview:tableView];

        self.tableView = tableView;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [menuDataSource numberOfObjects];
    }
    else if(section == 1)
    {
        return [notifyDataSource numberOfObjects];
    }
    return 0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        navigationMenuCell *cell = nil;
        if (cell == nil) {
            NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"navigationMenuCell" owner:self options:nil] ;
            cell = [nib objectAtIndex:0];
        }
        cell.iconImageView.image = [UIImage imageNamed:[menuDataSource iconImageAtIndex:indexPath.row]];
        cell.detailImageView.image = [UIImage imageNamed:[menuDataSource detailImageAtIndex:indexPath.row]];
        cell.titleLabel.text = [menuDataSource titleAtIndex:indexPath.row];
        
        [cell setNeedsDisplay];
        
        return cell;
    }
    else if(indexPath.section == 1)
    {
        navigationNotifyCell *cell = nil;
        
        if (cell == nil) {
            NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"navigationNotifyCell" owner:self options:nil] ;
            cell = [nib objectAtIndex:0];
            cell.headerIcon.image = [UIImage imageNamed:[notifyDataSource iconImageAtIndex:indexPath.row]];
            NSString *tempString = [notifyDataSource titleAtIndex:indexPath.row];
            cell.NotifyDetailLabel.text = tempString;
            
            [cell.NotifyDetailLabel setColor:[UIColor colorWithRed:237.0/255.0f green:237.0/255.0f blue:237.0/255.0f alpha:1.0] fromIndex:0 length:tempString.length];
            [cell.NotifyDetailLabel setFont:[UIFont systemFontOfSize:12] fromIndex:0 length:tempString.length];
            [cell.NotifyDetailLabel setFont:[UIFont boldSystemFontOfSize:12] fromIndex:0 length:4];
            [cell.NotifyDetailLabel setFont:[UIFont boldSystemFontOfSize:12] fromIndex:20 length:8];
        }
        [cell setNeedsDisplay];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [menuDataSource heightForCellAtIndex:indexPath.row];
    }
    else
    {
        return [notifyDataSource heightForCellAtIndex:indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 23;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"navigationNotifySectionHeader" owner:self options:nil] ;
        navigationNotifySectionHeader *header = [nib objectAtIndex:0];
        [header.title setText:@"NOTIFICATIONS"];
        [header setNeedsDisplay];
        return header;
    }
    else
    {
        return nil;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
