
#import "NavgationBar.h"
#import "DetailInviteesController.h"
#import "AddEventInvitePeopleHeaderView.h"
#import "AddEventInvitePeopleCell.h"
#import "ViewUtils.h"
#import "DetailDeclinedCell.h"
#import "DetailRespondedCell.h"

@interface respondedInfo:NSObject

@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) UIImage *headPhoto;
@property(nonatomic,strong) NSString *headPhotoUrl;
@property(nonatomic,strong) NSString *declinedTime;
@property(nonatomic,strong) NSMutableArray *declinedTimeArray;
@property(nonatomic,strong) NSMutableArray *agreeTimeArray;

@end

@implementation respondedInfo

@end


@interface DetailInviteesController ()<UITableViewDelegate,
                                           UITableViewDataSource,
                                           NavgationBarDelegate>
{
    NSMutableArray *respondedArray;
    NSMutableArray *declinedArray;
    NSMutableArray *notRespondedArray;
}

@end

@implementation DetailInviteesController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    
    NavgationBar * navBar = [[NavgationBar alloc] init];
    [navBar setTitle:@"Invitees"];
    [navBar setLeftBtnText:@"Cancel"];
    [navBar setRightBtnText:@"Add"];
    
    [self.view addSubview:navBar];
    navBar.delegate = self;

    self.tableView.delegate = self;
    self.tableView.dataSource =  self;
    
    [self.tableView reloadData];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}


- (void)initData
{
    respondedArray = [NSMutableArray array];
    declinedArray = [NSMutableArray array];
    notRespondedArray = [NSMutableArray array];
    
    for (NSInteger index = 0; index < 5; index++) {
        respondedInfo *responded = [[respondedInfo alloc] init];
        responded.name = @"Dov Mamann";
        responded.headPhoto = [UIImage imageNamed:[NSString stringWithFormat: @"header%d.jpg", index + 1]];
        responded.declinedTime = @"Declined 3 hours ago";
        
        responded.declinedTimeArray = [NSMutableArray array];
        responded.agreeTimeArray = [NSMutableArray array];
        
        for (NSInteger i = 0; i < 3; i++) {
            [responded.declinedTimeArray addObject:@"12:30pm-1:45pm"];
            [responded.agreeTimeArray addObject:@"5:30pm-7:45pm"];
        }
        
        [respondedArray addObject:responded];
        [declinedArray addObject:responded];
        [notRespondedArray addObject:responded];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    AddEventInvitePeopleHeaderView * header = (AddEventInvitePeopleHeaderView *)[ViewUtils createView:@"AddEventInvitePeopleHeaderView"];
    
    if(section == 0) {
        header.label.text = @"RESPONDED";
    } else if(section == 1){
        header.label.text = @"DECLINED EVENT";
    }
    else{
        header.label.text = @"NOT YET RESPONDED";
    }
    
    return header;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return [respondedArray count];
    }
    else if(section == 1)
    {
        return [declinedArray count];
    }
    else
    {
        return [notRespondedArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        DetailRespondedCell *cell = (DetailRespondedCell *)[ViewUtils createView:@"DetailRespondedCell"];
        respondedInfo *responded = [respondedArray objectAtIndex:row];
        [cell setName:responded.name];
        [cell setHeaderImage:responded.headPhoto];
        [cell setAgreeTime:responded.agreeTimeArray];
        [cell setDeclindTime:responded.declinedTimeArray];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(section == 1) {
        DetailDeclinedCell *cell = (DetailDeclinedCell *)[ViewUtils createView:@"DetailDeclinedCell"];
        
        respondedInfo *responded = [declinedArray objectAtIndex:row];
        [cell setName:responded.name];
        [cell setHeaderImage:responded.headPhoto];
        [cell setDeclinedTimeString:responded.declinedTime];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        AddEventInvitePeopleCell *cell = (AddEventInvitePeopleCell *)[ViewUtils createView:@"AddEventInvitePeopleCell"];
        
        respondedInfo *responded = [notRespondedArray objectAtIndex:row];
        cell.peopleName.text = responded.name;
        cell.peopleHeader.image = responded.headPhoto;
        [cell.btnSelect setHidden:YES];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (void)leftNavBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavBtnClick
{

}

@end





