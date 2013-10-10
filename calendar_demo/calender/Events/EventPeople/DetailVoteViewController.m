
#import "NavgationBar.h"
#import "DetailVoteViewController.h"

#import "AddEventInvitePeopleHeaderView.h"
#import "ViewUtils.h"

#import "DetailVoteCell.h"
#import "DetailVoteCreatorCell.h"

#import "Utils.h"
#import "LogUtil.h"


@interface DetailVoteViewController ()<UITableViewDelegate,
                                           UITableViewDataSource,
                                           NavgationBarDelegate>
{
    NSMutableArray *availablePeople;
    NSMutableArray *unAvailablePeople;
}

@end

@implementation DetailVoteViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    
    NSString * startTime = [Utils formateTimeAMPM: self.eventTime.start];
    NSString * endTime = [Utils formateTimeAMPM: [self.eventTime getEndTime]];
    
    NSString * time = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
    NSString * day = [Utils formateDay2:self.eventTime.start];
    
    NSString * title = [NSString stringWithFormat:@"%@\n%@", time , day];
    
    NavgationBar * navBar = [[NavgationBar alloc] init];
    [navBar setTitle:title];
    
    [navBar setLeftBtnText:@"Cancel"];
    [navBar setRightBtnHidden:YES];
    
    [self.view addSubview:navBar];
    navBar.delegate = self;

    self.tableView.delegate = self;
    self.tableView.dataSource =  self;
    
    [self.tableView reloadData];
}


- (void)initData
{
    availablePeople = [NSMutableArray array];
    unAvailablePeople = [NSMutableArray array];
    
    
    for(EventTimeVote * vote in self.eventTime.votes) {
        EventAttendee * attendee = [[self.event getAttendeesDic] objectForKey:vote.email];
        Contact * contact = attendee.contact;
        
        AddEventInvitePeople * people = [[AddEventInvitePeople alloc] init];
        people.user = contact;
        
        if(vote.status == 1) {
            [availablePeople addObject:people];
        } else {
            [unAvailablePeople addObject:people];
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
        header.label.text = @"AVAILABLE";
    } else if(section == 1){
        header.label.text = @"UNAVAILABLE";
    }
    return header;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 0;
    if(section == 0) {
        count =  [availablePeople count];
    }
    else
    {
        count = [unAvailablePeople count];
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) {

        AddEventInvitePeople * people = [availablePeople objectAtIndex:row];

        User * creator = self.event.creator;

        if([people.user.email isEqualToString:creator.email]) {

            DetailDeclinedCell * cell = (DetailDeclinedCell *)[ViewUtils createView:@"DetailDeclinedCell"];
            [cell setName: [creator getReadableUsername]];
            [cell setHeaderImageUrl:creator.avatar_url];
            [cell setAvaliable:YES];
            cell.declinedTime.text = @"Event Creator";
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;

        } else {

            AddEventInvitePeopleCell * cell = (AddEventInvitePeopleCell *)[ViewUtils createView:@"AddEventInvitePeopleCell"];
            [cell refreshView:people];
            [cell.btnSelect setHidden:YES];

            [cell setAvaliable:YES];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

            return cell;
        }
    }
    else
    {
        AddEventInvitePeople * people = [unAvailablePeople objectAtIndex:row];
        AddEventInvitePeopleCell *cell = (AddEventInvitePeopleCell *)[ViewUtils createView:@"AddEventInvitePeopleCell"];
        [cell refreshView:people];
        [cell.btnSelect setHidden:YES];
        
        [cell setAvaliable:NO];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (void)leftNavBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavBtnClick
{

}

@end





