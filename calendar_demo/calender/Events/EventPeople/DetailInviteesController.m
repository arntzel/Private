
#import "EventNavigationBar+GlassStyle.h"
#import "DetailInviteesController.h"
#import "AddEventInvitePeopleHeaderView.h"
#import "AddEventInvitePeopleCell.h"
#import "ViewUtils.h"
#import "DetailDeclinedCell.h"
#import "DetailRespondedCell.h"
#import "ViewUtils.h"
#import "Utils.h"
#import "ExtendArray.h"

#import "UserModel.h"

#import "AddEventInviteViewController.h"

typedef enum
{
    DetailInviteesResponsed = 0,
    DetailInviteesDeclined = 1,
    DetailInviteesNotRespond = 2,
}DetailInviteesState;

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
                                        EventNavigationBarDelegate,
                                        AddEventInviteViewControllerDelegate>
{
    ExtendArray *respondedArray;
    ExtendArray *declinedArray;
    ExtendArray *notRespondedArray;
    
    NSMutableArray *dataArray;
    
    UIButton *rightBtn;
}

@end

@implementation DetailInviteesController

- (void)setEvent:(Event *)event
{
    _event = event;
}

-(BOOL) isMyCreatEvent
{
    User * user =  [[UserModel getInstance] getLoginUser];
    User * creator = self.event.creator;
    return user.id == creator.id;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    
    EventNavigationBar * navBar = [EventNavigationBar creatView];
    [navBar setTitle:@"Invitees"];
    [navBar setGlassImage:self.titleBgImage];
    
    rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(242, 8, 70, 29)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"nav_roundbtn_bg.png"] forState:UIControlStateNormal];
    [rightBtn setTitle:@"+ Add" forState:UIControlStateNormal];
    [navBar addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(addInvitees) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:13]];
    [rightBtn.titleLabel setTextColor:[UIColor whiteColor]];
    
    if (![self isMyCreatEvent])
    {
        if (self.event.allow_attendee_invite) {
            [rightBtn setHidden:NO];
        }
        else
        {
            [rightBtn setHidden:YES];
        }
    }
    
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
    dataArray = [NSMutableArray array];
    
    respondedArray = [ExtendArray array];
    respondedArray.tag = DetailInviteesResponsed;
    
    declinedArray = [ExtendArray array];
    declinedArray.tag = DetailInviteesDeclined;
    
    notRespondedArray = [ExtendArray array];
    notRespondedArray.tag = DetailInviteesNotRespond;

    for(EventAttendee * atd in self.event.attendees) {
        
        Contact * contact = atd.contact;
        respondedInfo * responded = [[respondedInfo alloc] init];
        
        responded.name = [contact getReadableUsername];
        responded.headPhotoUrl = contact.avatar_url;
        
        
        responded.declinedTimeArray = [NSMutableArray array];
        responded.agreeTimeArray = [NSMutableArray array];
        
        
        if(atd.status == -1) {
            //Decline
            NSString * time = [Utils getTimeText:atd.modified];
            responded.declinedTime = [NSString stringWithFormat:@"Declined %@", time];
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
    
    if ([respondedArray count] > 0) {
        [dataArray addObject:respondedArray];
    }
    if ([declinedArray count] > 0) {
        [dataArray addObject:declinedArray];
    }
    if ([notRespondedArray count] > 0) {
        [dataArray addObject:notRespondedArray];
    }
}

- (void)addInvitees
{
    AddEventInviteViewController *controller = [[AddEventInviteViewController alloc] initWithNibName:@"AddEventInviteViewController" bundle:nil];
    controller.delegate = self;
    
    NSMutableArray *userArray = [NSMutableArray array];
    for (EventAttendee *attend in self.event.attendees)
    {
        [userArray addObject:attend.contact];
    }
    
    [controller setType:AddInviteeTypeRest];
    [controller setSelectedUser:userArray];
    
    [self.navigationController pushViewController:controller animated:YES];
    
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
    
    ExtendArray *array = [dataArray objectAtIndex:section];
    if(array.tag == DetailInviteesResponsed) {
        header.label.text = @"RESPONDED";
    } else if(array.tag == DetailInviteesDeclined){
        header.label.text = @"DECLINED EVENT";
    }
    else{
        header.label.text = @"NOT YET RESPONDED";
    }
    
    return header;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *array = [dataArray objectAtIndex:section];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    ExtendArray *array = [dataArray objectAtIndex:section];
    switch (array.tag) {
        case DetailInviteesResponsed:
        {
            DetailRespondedCell *cell = (DetailRespondedCell *)[ViewUtils createView:@"DetailRespondedCell"];
            respondedInfo *responded = [array objectAtIndex:row];
            [cell setName:responded.name];
            [cell setHeaderImageUrl:responded.headPhotoUrl];
            [cell setAgreeTime:responded.agreeTimeArray];
            [cell setDeclindTime:responded.declinedTimeArray];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case DetailInviteesDeclined:
        {
            DetailDeclinedCell *cell = (DetailDeclinedCell *)[ViewUtils createView:@"DetailDeclinedCell"];
            
            respondedInfo *responded = [array objectAtIndex:row];
            [cell setName:responded.name];
            [cell setHeaderImageUrl:responded.headPhotoUrl];
            [cell setDeclinedTimeString:responded.declinedTime];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case DetailInviteesNotRespond:
        default:
        {
            AddEventInvitePeopleCell *cell = (AddEventInvitePeopleCell *)[ViewUtils createView:@"AddEventInvitePeopleCell"];
            
            respondedInfo *responded = [array objectAtIndex:row];
            cell.peopleName.text = responded.name;
            [cell setHeaderImageUrl:responded.headPhotoUrl];
            [cell.btnSelect setHidden:YES];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [dataArray count];
}

- (void)leftBtnPress:(id)sender;
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark AddEventInviteViewControllerDelegate
- (void)setInVitePeopleArray:(NSArray *)inviteArray
{
    if ([inviteArray count] > 0) {
        NSArray *array = [self convertResponsedArrayFromContactArray:inviteArray];
        [dataArray removeObject:notRespondedArray];
        [dataArray addObject:notRespondedArray];
        [notRespondedArray addObjectFromArray:array];
        [self.tableView reloadData];
        
        if ([self.delegate respondsToSelector:@selector(addNewPeopleArray:)]) {
            [self.delegate addNewPeopleArray:inviteArray];
        }
    }
}

- (NSArray *)convertResponsedArrayFromContactArray:(NSArray *)contacts
{
    NSMutableArray *array = [NSMutableArray array];
    for (Contact *contact in contacts)
    {
        respondedInfo * responded = [[respondedInfo alloc] init];
        
        responded.name = [contact getReadableUsername];
        responded.headPhotoUrl = contact.avatar_url;
        
        [array addObject:responded];
    }
    
    return array;
}

@end





