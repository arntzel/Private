
#import "menuViewController.h"
#import "navigationMenuCell.h"
#import "navigationNotifyCell.h"
#import "navigationNotifySectionHeader.h"

#import "navigationMenuDataSource.h"
#import "navigationNotifyDataSource.h"

@interface menuViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    navigationMenuDataSource *menuDataSource;
    navigationNotifyDataSource *notifyDataSource;
}

@end

@implementation menuViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    menuDataSource = [[navigationMenuDataSource alloc] init];
    notifyDataSource = [[navigationNotifyDataSource alloc] init];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.bounces = NO;

	// Do any additional setup after loading the view, typically from a nib.
}

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
            cell.NotifyDetailLabel.text = [notifyDataSource titleAtIndex:indexPath.row];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [menuDataSource release];
    [notifyDataSource release];

    
    [_tableView release];
    [super dealloc];
}
@end
