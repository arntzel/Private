

#import "PendingTableView.h"
#import "PendingEventViewCell.h"
#import "PendingEventViewCell2.h"



@interface PendingTableView() <UITableViewDataSource, UITableViewDelegate>

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
    self.headerEnabled = YES;
    self.tailerEnabled = NO;
    
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
    return eventList.count;
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
    Event * evt = [eventList objectAtIndex:row];

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

    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"PendingEventHeader" owner:self options:nil];
    UIView * header = [nibView objectAtIndex:0];
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

@end
