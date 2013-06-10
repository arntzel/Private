
#import "menuViewController.h"
#import "navigationMenuCell.h"
#import "navigationNotifyCell.h"
#import "navigationNotifySectionHeader.h"

@interface menuViewController ()<UITableViewDelegate,UITableViewDataSource>

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
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.bounces = NO;

	// Do any additional setup after loading the view, typically from a nib.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    else if(section == 1)
    {
        return 10;
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
        static NSString *CellIdentifier1 = @"navigationMenuCell";
        
        navigationMenuCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil) {
            NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"navigationMenuCell" owner:self options:nil] ;
            cell = [nib objectAtIndex:0];
        }
        if (indexPath.row == 0) {
            cell.iconImageView.image = [UIImage imageNamed:@"manuNavCal.png"];
        }
        else if (indexPath.row == 1) {
            cell.iconImageView.image = [UIImage imageNamed:@"manuNavQuestion.png"];
        }
        else if (indexPath.row == 2) {
            cell.detailImageView.image = [UIImage imageNamed:@"manuNavSetting.png"];
        }
        
        
        return cell;
    }
    else if(indexPath.section == 1)
    {
        static NSString *CellIdentifier2 = @"navigationNotifyCell";
        
        navigationNotifyCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"navigationNotifyCell" owner:self options:nil] ;
            cell = [nib objectAtIndex:0];
            cell.headerIcon.image = [UIImage imageNamed:@"manuHeadImage.jpg"];
        }
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 55.0f;
    }
    else
    {
        return 66.0f;
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
        return header;
    }
    else
    {
        return nil;
    }
    
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return [NSArray arrayWithObjects:@"", @"NOTIFICATIONS", nil];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
