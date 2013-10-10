
#import "NavgationBar.h"
#import "DetailInviteesController.h"
#import "AddEventInvitePeopleHeaderView.h"
#import "AddEventInvitePeopleCell.h"
#import "ViewUtils.h"
#import "DetailDeclinedCell.h"
#import "DetailRespondedCell.h"
#import "ViewUtils.h"

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
    
    
    for(EventAttendee * atd in self.event.attendees) {
        
        Contact * contact = atd.contact;
        respondedInfo * responded = [[respondedInfo alloc] init];
        
        responded.name = [contact getReadableUsername];
        responded.headPhotoUrl = contact.avatar_url;
        
        
        responded.declinedTimeArray = [NSMutableArray array];
        responded.agreeTimeArray = [NSMutableArray array];
        
        
        if(atd.status == -1) {
            //Decline
            responded.declinedTime = @"Decline";
            [declinedArray addObject:responded];
            continue;
        }
        
        BOOL responsed = NO;
        
        for(ProposeStart * start in self.event.propose_starts) {
            for(EventTimeVote * vote in start.votes) {
                
                if([vote.email isEqualToString:contact.email]) {
                    
                    if(vote.status == 1) {
                        [responded.agreeTimeArray addObject: [start getVoteTimeLabel]];
                    } else {
                        [responded.declinedTimeArray addObject: [start getVoteTimeLabel]];
                    }
                    
                    responsed = YES;
                    break;
                }
            }
        }
        
        if(responsed) {
            [respondedArray addObject:responded];
        } else {
            [notRespondedArray addObject:responded];
        }
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
    int count = 0;
    if(section == 0) {
        count = [respondedArray count];
    }
    else if(section == 1)
    {
        count = [declinedArray count];
    }
    else
    {
        count = [notRespondedArray count];
    }
    
    return count > 0 ? count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        
        if(respondedArray.count == 0) {
            return (UITableViewCell *)[ViewUtils createView:@"EmptyCell"];
        }
        
        
        DetailRespondedCell *cell = (DetailRespondedCell *)[ViewUtils createView:@"DetailRespondedCell"];
        respondedInfo *responded = [respondedArray objectAtIndex:row];
        [cell setName:responded.name];
        [cell setHeaderImageUrl:responded.headPhotoUrl];
        [cell setAgreeTime:responded.agreeTimeArray];
        [cell setDeclindTime:responded.declinedTimeArray];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(section == 1) {
        
        if(declinedArray.count == 0) {
            return (UITableViewCell *)[ViewUtils createView:@"EmptyCell"];
        }
        
        DetailDeclinedCell *cell = (DetailDeclinedCell *)[ViewUtils createView:@"DetailDeclinedCell"];
        
        respondedInfo *responded = [declinedArray objectAtIndex:row];
        [cell setName:responded.name];
        [cell setHeaderImageUrl:responded.headPhotoUrl];
        [cell setDeclinedTimeString:responded.declinedTime];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        if(notRespondedArray.count == 0) {
            return (UITableViewCell *)[ViewUtils createView:@"EmptyCell"];
        }
        
        AddEventInvitePeopleCell *cell = (AddEventInvitePeopleCell *)[ViewUtils createView:@"AddEventInvitePeopleCell"];
        
        respondedInfo *responded = [notRespondedArray objectAtIndex:row];
        cell.peopleName.text = responded.name;
        [cell setHeaderImageUrl:responded.headPhotoUrl];
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





