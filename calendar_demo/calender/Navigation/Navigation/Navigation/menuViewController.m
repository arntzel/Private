
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
        
        return cell;
    }
    else if(indexPath.section == 1)
    {
        static NSString *CellIdentifier2 = @"navigationNotifyCell";
        
        navigationMenuCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"navigationNotifyCell" owner:self options:nil] ;
            cell = [nib objectAtIndex:0];
        }
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 44;
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
