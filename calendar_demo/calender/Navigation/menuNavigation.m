#import "menuNavigation.h"
#import "DDMenuController.h"

#import "navigationMenuCell.h"
#import "navigationNotifyCell.h"
#import "navigationNotifySectionHeader.h"

#import "navigationMenuDataSource.h"
#import "navigationNotifyDataSource.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "Model.h"

@interface menuNavigation()<UITableViewDelegate,UITableViewDataSource>
{
    navigationMenuDataSource *menuDataSource;
    //navigationNotifyDataSource *notifyDataSource;
    NSArray * _messages;
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
    //notifyDataSource = [[navigationNotifyDataSource alloc] init];
    
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
    
    [[Model getInstance] getMessages:^(NSInteger error, NSArray *messages) {
        
        if(error == 0) {
            _messages = messages;
            [self.tableView reloadData];
        } else {
            //TODO::
        }
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [menuDataSource numberOfObjects];
    }
    else if(section == 1)
    {
        return [_messages count];
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
            
            Message * msg = [_messages objectAtIndex:indexPath.row];
            [cell refreshView:msg];
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
        //return [notifyDataSource heightForCellAtIndex:indexPath.row];
        return 55;
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
