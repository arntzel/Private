#import "menuNavigation.h"
#import "DDMenuController.h"

#import "navigationMenuCell.h"
#import "navigationNotifyCell.h"
#import "navigationNotifySectionHeader.h"

#import "navigationMenuDataSource.h"
#import "navigationNotifyDataSource.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

#import "UserModel.h"
#import "Model.h"

#import "RootNavContrller.h"
#import "PedingEventViewController.h"


@interface menuNavigation()<UITableViewDelegate,UITableViewDataSource>
{
    navigationMenuDataSource *menuDataSource;
    NSArray * _messages;
    BOOL loading;
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
    
    loading = YES;
    [self.tableView reloadData];
    [[Model getInstance] getMessages:^(NSInteger error, NSArray *messages) {
        
        if(error == 0) {
            _messages = messages;
        } else {
            //TODO::
        }
        
        loading = NO;
        
        [self.tableView reloadData];

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
        
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"navigationMenuCell" owner:self options:nil] ;
        navigationMenuCell * cell = [nib objectAtIndex:0];
        
        if(indexPath.row == 2) {
            
            NSString * headerUrl = [[UserModel getInstance] getLoginUser].avatar_url;
            
            cell.iconImageView.layer.cornerRadius = cell.iconImageView.frame.size.width/2;
            cell.iconImageView.layer.masksToBounds = YES;

            if([headerUrl isKindOfClass: [NSNull class]]) {
                cell.iconImageView.image = [UIImage imageNamed:@"header.png"];
            } else {
                [cell.iconImageView setImageWithURL:[NSURL URLWithString:headerUrl]
                                placeholderImage:[UIImage imageNamed:@"header.png"]];
            }
            
            cell.detailImageView.image = [UIImage imageNamed:[menuDataSource detailImageAtIndex:indexPath.row]];
            cell.titleLabel.text = [[UserModel getInstance] getLoginUser].username;
            
        } else {
            cell.iconImageView.image = [UIImage imageNamed:[menuDataSource iconImageAtIndex:indexPath.row]];
            cell.detailImageView.image = [UIImage imageNamed:[menuDataSource detailImageAtIndex:indexPath.row]];
            cell.titleLabel.text = [menuDataSource titleAtIndex:indexPath.row];
        }
        
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
        
        if(loading) {
            [header.loadingView startAnimating];
        } else {
            header.loadingView.hidden = YES;
        }
        
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
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];

    NSLog(@"didSelectRowAtIndexPath:%@", indexPath);

    if(indexPath.section ==0) {
        [self.delegate onMenuSelected:indexPath.row];
    }

}
@end
