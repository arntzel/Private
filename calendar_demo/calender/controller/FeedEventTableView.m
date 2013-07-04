
#import "FeedEventTableView.h"
#import "Event.h"
#import "EventView.h"
#import "Utils.h"


@interface FeedEventTableView() <UITableViewDataSource, UITableViewDelegate>

@end


@implementation FeedEventTableView {
    EventModel * eventModel;
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
   
    self.headerEnabled = YES;
    self.tailerEnabled = NO;

    self.dataSource = self;
    self.delegate = self;
    
}

-(void) setEventModel:(EventModel *) _eventModel {
    eventModel = _eventModel;
    [self reloadData];
}


#pragma mark -
#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSLog(@"numberOfRowsInSection:%d", section);

    NSArray * allDays = [eventModel getAllDays];

    NSString * key = [allDays objectAtIndex:section];

    NSArray * array = [eventModel getEventsByDay:key];

    NSLog(@"section=%d, count=%d/%d, key=%@", section, array.count, allDays.count, key);

    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;

    NSLog(@"cellForRowAtIndexPath: %d, %d", section, row);

    NSArray * allDays = [eventModel getAllDays];

    NSString * key = [allDays objectAtIndex:section];

    NSArray * dayEvents = [eventModel getEventsByDay:key];

    Event * event = [dayEvents objectAtIndex:row];
    EventView * view = [EventView createEventView];

    [view refreshView:event];

    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eventView"];
    [cell addSubview:view];
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray * allDays = [eventModel getAllDays];

    NSString * sectionName = [allDays objectAtIndex:section];

    sectionName = [Utils toReadableDay:sectionName];

    CGRect frame = CGRectMake(0, 0, 320, 24);

    UIView * view = [[UIView alloc] initWithFrame:frame];
    UIImageView * bg = [[UIImageView alloc] initWithFrame:frame];
    bg.image = [UIImage imageNamed:@"bg_section_header"];
    [view addSubview:bg];

    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(65, 0, 1, 24)];
    float colorVal = 227.0/255.0;
    line.backgroundColor = [UIColor colorWithRed:colorVal green:colorVal blue:colorVal alpha:1];
    [view addSubview:line];

    UIImageView * dotView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"dot"]];
    dotView.frame = CGRectMake(60.5, 7, 10, 10);
    [view addSubview:dotView];

    float fontColor = 172.0/255.0;

    UILabel * dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 5, 320-68, 16)];
    dayLabel.text = sectionName;
    dayLabel.textColor = [UIColor colorWithRed:fontColor green:fontColor blue:fontColor alpha:1];
    dayLabel.font = [UIFont fontWithName:@"Arial" size:12];
    dayLabel.textAlignment = UITextAlignmentLeft;
    dayLabel.backgroundColor = [UIColor clearColor];

    [view addSubview:dayLabel];

    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[eventModel getAllDays] count];
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return PlanView_HEIGHT;
}
@end
