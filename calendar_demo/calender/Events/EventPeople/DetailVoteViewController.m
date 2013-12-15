
#import "EventDateNavigationBar+GlassStyle.h"
#import "DetailVoteViewController.h"

#import "AddEventInvitePeopleHeaderView.h"
#import "ViewUtils.h"

#import "DetailVoteCell.h"
#import "DetailVoteCreatorCell.h"

#import "Utils.h"
#import "LogUtil.h"
#import "ExtendArray.h"

typedef enum
{
    DetailVoteAvilable = 0,
    DetailVoteUnAvilable = 1,
}DetailVoteState;

@interface DetailVoteViewController ()<UITableViewDelegate,
                                           UITableViewDataSource,
                                           EventDateNavigationBarDelegate>
{
    ExtendArray *availablePeople;
    ExtendArray *unAvailablePeople;
    
    NSMutableArray *dataArray;
    
    EventDateNavigationBar * navBar;
}

@end

@implementation DetailVoteViewController

- (void)awakeFromNib
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self initData];
    
    NSString * startTime = [Utils formateTimeAMPM: self.eventTime.start];
    NSString * endTime = [Utils formateTimeAMPM: [self.eventTime getEndTime]];
    
    NSString * time = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
    NSString * day = [Utils formateDay2:self.eventTime.start];
    
    navBar = [EventDateNavigationBar creatView];
    [navBar setTitle:time];
    [navBar setDescription:day];
    [navBar setGlassImage:self.titleBgImage];
    [self.view addSubview:navBar];
    navBar.delegate = self;

    self.tableView.delegate = self;
    self.tableView.dataSource =  self;
    
    [self.tableView reloadData];
}


- (void)initData
{
    dataArray = [NSMutableArray array];
    
    availablePeople = [ExtendArray array];
    availablePeople.tag = DetailVoteAvilable;
    unAvailablePeople = [ExtendArray array];
    unAvailablePeople.tag = DetailVoteUnAvilable;
    
    
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
    
    if ([availablePeople count] > 0) {
        [dataArray addObject:availablePeople];
    }
    if ([unAvailablePeople count] > 0) {
        [dataArray addObject:unAvailablePeople];
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
    ExtendArray *array = [dataArray objectAtIndex:section];
    if(array.tag == DetailVoteAvilable) {
        header.label.text = @"AVAILABLE";
    }
    else
    {
        header.label.text = @"UNAVAILABLE";
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
        case DetailVoteAvilable:
        {
            AddEventInvitePeople * people = [availablePeople objectAtIndex:row];
            
            User * creator = self.event.creator;
            
            if([people.user.email caseInsensitiveCompare:creator.email] == NSOrderedSame) {
                
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
            break;
        case DetailVoteUnAvilable:
        default:
        {
            AddEventInvitePeople * people = [unAvailablePeople objectAtIndex:row];
            AddEventInvitePeopleCell *cell = (AddEventInvitePeopleCell *)[ViewUtils createView:@"AddEventInvitePeopleCell"];
            [cell refreshView:people];
            [cell.btnSelect setHidden:YES];
            
            [cell setAvaliable:NO];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return cell;
        }
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [dataArray count];
}

- (void)leftBtnPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end





