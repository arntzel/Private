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

#import "Utils.h"
#import "ViewUtils.h"
#import "EventDetailController.h"
#import "BLRView.h"

#define BANNER_HEIGHT 55
#define BANNER_LEFT_MARGIN 20

@interface menuNavigation()<UITableViewDelegate,UITableViewDataSource, MessageModelDelegate >
{
    navigationMenuDataSource *menuDataSource;
    //NSArray * _messages;
    BOOL loading;
    
    MessageModel * msgModel;
}
@end


@implementation menuNavigation

@synthesize tableView=_tableView;


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
    
    self.view.clipsToBounds = YES;
    
    //Load BLRView
    BLRView *blrView = [[BLRView alloc] init];
    blrView.frame = self.view.bounds;
    blrView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [blrView  blurWithColor:[BLRColorComponents blueEffect]];
    [self.view addSubview:blrView];
    
    menuDataSource = [[navigationMenuDataSource alloc] init];
    
    //CGRect bannerRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    CGRect tableRect = CGRectMake(0, BANNER_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - BANNER_HEIGHT);
    
    UIView *sepLine = [[UIView alloc]initWithFrame:CGRectMake(20, 75, 280, 1)];
    [sepLine setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:sepLine];
    
    CGRect logoRect = CGRectMake(20, 40, 64, 20);
    
    //UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:logoRect];
    UIButton *logoButton = [[UIButton alloc]initWithFrame:logoRect];
    
    UIImage *logoImage = [UIImage imageNamed:@"Calvin_logo"];
    [logoButton setImage:logoImage forState:UIControlStateNormal];
    [logoButton addTarget:self action:@selector(onLogoButtonTyped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoButton];
    
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(266, 30, 50, 50)];
    [closeBtn setImage:[UIImage imageNamed:@"add_icon"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(onCloseButtonTyped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.bounces = YES;
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        //tableView.backgroundColor = [UIColor colorWithRed:75.0/255.0f green:80.0/255.0f blue:85.0/255.0f alpha:1.0];
        [tableView setBackgroundColor:[UIColor clearColor]];
        tableView.dataSource = self;
        tableView.delegate = self;
        
        
        [self.view addSubview:tableView];

        self.tableView = tableView;
    }
    
   
    
    msgModel = [[Model getInstance] getMessageModel];
    [msgModel addDelegate:self];
    [msgModel refreshModel:nil];
    
    NSIndexPath * path = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    UIButton *settingBtn = [[UIButton alloc]initWithFrame:CGRectMake(266, 510, 50, 50)];
    [settingBtn setImage:[UIImage imageNamed:@"settings_icon"] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(onSettingButtonTyped) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:settingBtn aboveSubview:self.tableView];
}

- (void)viewWillUnload {
    [msgModel removeDelegate:self];
    [super viewWillUnload];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [msgModel getMessagesCount];
//    if (section == 0) {
//        return [menuDataSource numberOfObjects];
//    }
//    else if(section == 1)
//    {
//        return  [msgModel getMessagesCount];
//    }
//    return 0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    navigationNotifyCell *cell = nil;
    
    if (cell == nil) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"navigationNotifyCell" owner:self options:nil] ;
        cell = [nib objectAtIndex:0];
        
        MessageEntity * msg = [msgModel getMessage:indexPath.row];
        [cell refreshView:msg];
    }
    
    [cell setNeedsDisplay];
    return cell;
    
//    if (indexPath.section == 0) {
//
//        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"navigationMenuCell" owner:self options:nil] ;
//        navigationMenuCell * cell = [nib objectAtIndex:0];
//        
//        if(indexPath.row == 2) {
//            
//            NSString * headerUrl = [[UserModel getInstance] getLoginUser].avatar_url;
//            
//            cell.iconImageView.layer.cornerRadius = cell.iconImageView.frame.size.width/2;
//            cell.iconImageView.layer.masksToBounds = YES;
//
//            if([headerUrl isKindOfClass: [NSNull class]]) {
//                cell.iconImageView.image = [UIImage imageNamed:@"header.png"];
//            } else {
//                [cell.iconImageView setImageWithURL:[NSURL URLWithString:headerUrl]
//                                placeholderImage:[UIImage imageNamed:@"header.png"]];
//            }
//            
//            cell.detailImageView.image = [UIImage imageNamed:[menuDataSource detailImageAtIndex:indexPath.row]];
//            cell.titleLabel.text = [[[UserModel getInstance] getLoginUser] getReadableUsername];
//            
//        } else {
//            cell.iconImageView.image = [UIImage imageNamed:[menuDataSource iconImageAtIndex:indexPath.row]];
//            cell.detailImageView.image = [UIImage imageNamed:[menuDataSource detailImageAtIndex:indexPath.row]];
//            cell.titleLabel.text = [menuDataSource titleAtIndex:indexPath.row];
//        }
//        
//        [cell setNeedsDisplay];
//        
//        return cell;
//    }
//    else if(indexPath.section == 1)
//    {
//        navigationNotifyCell *cell = nil;
//        
//        if (cell == nil) {
//            NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"navigationNotifyCell" owner:self options:nil] ;
//            cell = [nib objectAtIndex:0];
//            
//            MessageEntity * msg = [msgModel getMessage:indexPath.row];
//            [cell refreshView:msg];
//        }
//        
//        [cell setNeedsDisplay];
//        return cell;
//    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
//    if (indexPath.section == 0) {
//        return [menuDataSource heightForCellAtIndex:indexPath.row];
//    }
//    else
//    {
//        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
//        return cell.frame.size.height;
////        return [menuDataSource heightForCellAtIndex:indexPath.row];
////        return 55;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 23;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"navigationNotifySectionHeader" owner:self options:nil] ;
    navigationNotifySectionHeader *header = [nib objectAtIndex:0];
    //[header.title setText:@"NOTIFICATIONS"];
    
    if(loading) {
        [header.loadingView startAnimating];
    } else {
        header.loadingView.hidden = YES;
    }
    
    [header setNeedsDisplay];
    
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LOG_D(@"didSelectRowAtIndexPath:%@", indexPath);
    
    MessageEntity * msg = [msgModel getMessage:indexPath.row];
    
    if([msg.eventID intValue] > 0) {
        EventDetailController * detailCtl = [[EventDetailController alloc] init];
        detailCtl.eventID = [msg.eventID intValue];
        [[RootNavContrller defaultInstance] pushViewController:detailCtl animated:YES];
    }
    
    if([msg.unread boolValue]) {
        [msgModel readMessage:msg];
    }

//    if(indexPath.section ==0) {
//        [self.delegate onMenuSelected:indexPath.row];
//    } else {
//        MessageEntity * msg = [msgModel getMessage:indexPath.row];
//
//        if([msg.eventID intValue] > 0) {
//            EventDetailController * detailCtl = [[EventDetailController alloc] init];
//            detailCtl.eventID = [msg.eventID intValue];
//            [[RootNavContrller defaultInstance] pushViewController:detailCtl animated:YES];
//        }
//        
//        if([msg.unread boolValue]) {
//            [msgModel readMessage:msg];
//        }
//    }
}

-(void) onMessageModelChanged
{
    [self reload];
}

-(void) onLoadDataStatusChanged:(BOOL) isLoading
{
    loading = isLoading;
    [self reload];
}

-(void) reload
{
    //NSIndexPath * selectPath = [_tableView indexPathForSelectedRow];
    
    [_tableView reloadData];
    
//    if(selectPath != nil && selectPath.section == 0) {
//        [_tableView selectRowAtIndexPath:selectPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//    }
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)onCloseButtonTyped
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)onSettingButtonTyped
{
    //[self onCloseButtonTyped];
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:^ {
        [self.delegate onSettingButtonTyped];
    }];
}

-(void)onLogoButtonTyped
{
    //[self onCloseButtonTyped];
    [self dismissViewControllerAnimated:YES completion:^ {
        [self.delegate onLogoButtonTyped];
    }];
}

@end
