

#import "PendingTableView.h"
#import "PendingEventViewCell.h"
#import "PendingEventViewCell2.h"
#import "EventDetailController.h"
#import "RootNavContrller.h"

#import "ViewUtils.h"

@interface PendingTableView() <UITableViewDataSource, UITableViewDelegate, PopDelegate>

@end

@implementation PendingTableView 
{
    NSMutableArray * completedEvents;
    NSMutableArray * pendingEvents;
    NSString * sectionHeader;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initTableView];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initTableView];
    }

    return self;
}


-(void) initTableView {
    completedEvents = [[NSMutableArray alloc] init];
    pendingEvents = [[NSMutableArray alloc] init];

    sectionHeader = @"";

    //self.backgroundColor = [UIColor grayColor];
    //self.headerEnabled = YES;
    //self.tailerEnabled = NO;
    
    self.dataSource = self;
    self.delegate = self;
    
}

-(void) setSectionHeader:(NSString *) header
{
    sectionHeader = header;
}

-(void) setCompletedEvents:(NSMutableArray *) completedEvts andPendingEvents:(NSMutableArray *) pendingEvs

{
    completedEvents = completedEvts;
    pendingEvents = pendingEvs;
}

#pragma mark -
#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * eventList = [self getEventsList:section];
    int rows = eventList.count;
    
    return rows > 0 ? rows : 1;
}


-(NSArray *) getEventsList:(int)section
{
    NSArray * array;
    if(section == 0) {
        array = completedEvents;
    } else {
        array = pendingEvents;
    }
    return array;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    int section = indexPath.section;
    int row = indexPath.row;

    NSArray * eventList = [self getEventsList:section];
    
    
    if(eventList.count == 0)
    {
        return (UITableViewCell *)[ViewUtils createView:@"PendingEventViewNoEventCell"];
    }
    
    FeedEventEntity * evt = [eventList objectAtIndex:row];
    
    if(section == 0) {
        PendingEventViewCell * cell = [PendingEventViewCell createView];
        [cell refreshView:evt];
        return cell;
    } else {
        PendingEventViewCell2 * cell = [PendingEventViewCell2 createView];
        [cell refreshView:evt];
        return cell;
    }

}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    if(section == 0) {
        return nil;
    }

    UIView * header = [ViewUtils createView:@"PendingEventHeader"];
    UILabel * label =  (UILabel *) [header viewWithTag:1];
    label.text = sectionHeader;

    return header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return pendingEvents.count == 0 ? 1 : 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    } else {
        return 24;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        return 75;
    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LOG_D(@"tableView:didSelectRowAtIndexPath:%@", indexPath);

    int section = indexPath.section;
    int row = indexPath.row;

    NSArray * eventList = [self getEventsList:section];

    if(eventList.count>0) {
        FeedEventEntity * event = [eventList objectAtIndex:row];

        if( [event isCalvinEvent] ) {
            EventDetailController * detailCtl = [[EventDetailController alloc] init];
            detailCtl.popDelegate = self;
            detailCtl.eventID = [event.id intValue];
            [[RootNavContrller defaultInstance] pushViewController:detailCtl animated:YES];
        }
    }
}

-(void)onControlledPopped:(BOOL)dataChanged
{
    [self reloadData];
    [self.popDelegate onControlledPopped:dataChanged];
}

#pragma mark -
#pragma mark AddEventViewDelegate
-(void) onEventCreated:(Event *) event
{
    //No implements, should be overwrited by children class
}
@end
