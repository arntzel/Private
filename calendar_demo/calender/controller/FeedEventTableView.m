
#import "FeedEventTableView.h"
#import "Event.h"
#import "EventView.h"
#import "BirthdayEventView.h"
#import "Utils.h"
#import "ViewUtils.h"

#import "EventDetailViewController.h"
#import "EventDetailController.h"

#import "RootNavContrller.h"
#import "NSDateAdditions.h"
#import "CoreDataModel.h"
#import "DayFeedEventEntitysExtra.h"
#import "FeedEventEntity.h"

@interface FeedEventTableView() <UITableViewDataSource, UITableViewDelegate>

@end


@implementation FeedEventTableView {
    NSString * currentFirstDay;
    CoreDataModel * model;
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
  
    self.dataSource = self;
    self.delegate = self;

    model = [CoreDataModel getInstance];
}


#pragma mark -
#pragma mark tableViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    NSArray * indexs = [self indexPathsForVisibleRows];
    
    if(indexs.count > 0) {
        NSIndexPath * path = [indexs objectAtIndex:0];
        NSDate * date = [self.beginDate cc_dateByMovingToTheFollowingDayCout:path.section];
        if(self.feedEventdelegate != nil) {
            [self.feedEventdelegate onDisplayFirstDayChanged:date];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    DayFeedEventEntitys * entitys = [self getEventEntity:section];

    if(entitys == nil) {
        return 1;
    }

    NSArray * events = [self getFeedEvents:entitys];
    return events.count > 0 ? events.count : 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    DayFeedEventEntitys * entitys = [self getEventEntity:indexPath.section];

    if(entitys == nil) {
        UITableViewCell * cell = (UITableViewCell *)[ViewUtils createView:@"NoEventView"];
        return cell;
    }

    NSArray * events = [self getFeedEvents:entitys];
    if(events.count == 0) {
        UITableViewCell * cell = (UITableViewCell *)[ViewUtils createView:@"NoEventView"];
        return cell;
    }

    
    FeedEventEntity * event = [events objectAtIndex:indexPath.row];
    
    if([event.eventType intValue] != 4) {
        EventView * view = [EventView createEventView];

        [view refreshView:event];

        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eventView"];
        [cell addSubview:view];
        return cell;

    } else {
        BirthdayEventView * view = [BirthdayEventView createEventView];

        [view refreshView:event];

        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"birthdayEventView"];
        [cell addSubview:view];
        return cell;

    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDate * date = [self.beginDate cc_dateByMovingToTheFollowingDayCout:section];
    NSString * sectionName = [Utils formateDay:date];
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

    UILabel * dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 4, 320-68, 16)];
    dayLabel.text = sectionName;
    dayLabel.textColor = [UIColor colorWithRed:fontColor green:fontColor blue:fontColor alpha:1];
    dayLabel.font = [UIFont systemFontOfSize:12];
    dayLabel.textAlignment = UITextAlignmentLeft;
    dayLabel.backgroundColor = [UIColor clearColor];

    [view addSubview:dayLabel];

    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSDate * endData = [self.beginDate cc_dateByMovingToThePreviousDayCout:365];
    int days  =  [endData cc_DaysBetween:self.beginDate];
    return days;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DayFeedEventEntitys * entitys = [self getEventEntity:indexPath.section];

    if(entitys == nil) {
        return 55;
    }

    NSArray * events = [self getFeedEvents:entitys];
    if(events.count == 0) {
        return 55;
    }

    FeedEventEntity * event = [events objectAtIndex:indexPath.row];
    
    if([event.eventType intValue] == 4) {
        return BirthdayEventView_Height;
    } else {
        return PlanView_HEIGHT;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LOG_D(@"tableView:didSelectRowAtIndexPath:%@", indexPath);

//    Event * event = [self getEvent:indexPath];

    EventDetailController * detailCtl = [[EventDetailController alloc] init];
//    [detailCtl setEvent:event];

    [[RootNavContrller defaultInstance] pushViewController:detailCtl animated:YES];
}

-(DayFeedEventEntitys *) getEventEntity:(int) section
{
    NSDate * date = [self.beginDate cc_dateByMovingToTheFollowingDayCout:section];
    NSString * day = [Utils formateDay:date];
    DayFeedEventEntitys * entitys =[model getDayFeedEventEntitys:day];
    return entitys;
}

-(NSArray *) getFeedEvents:(DayFeedEventEntitys *) entitys
{
   
    NSMutableArray *  events = [[NSMutableArray alloc] init];
    for(FeedEventEntity * entity in entitys.events) {
        int type = 0x00000001 << [entity.eventType intValue];;
        if( (type & self.eventTypeFilters) != 0) {
            [events addObject:entity];
        }
    }

    if(events.count ==0) {
        return events;
    }

    NSArray * sortedArray = [events sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        FeedEventEntity * evt1 = obj1;
        FeedEventEntity * evt2 = obj2;
        return [evt1.start compare:evt2.start];
    }];
    
    return sortedArray;
}

@end
