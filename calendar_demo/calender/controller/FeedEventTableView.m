
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
#import "FeedEventEntity.h"

#define FETECH_DAYS 15

@interface FeedEventTableView() <UITableViewDataSource, UITableViewDelegate>

@end


@implementation FeedEventTableView {
    NSString * currentFirstDay;
    CoreDataModel * model;
    DataCache * cache;
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
    cache = [model getCache];
}

-(NSDate *) getFirstVisibleDay
{
    NSArray * indexs = [self indexPathsForVisibleRows];

    if(indexs.count > 0) {
        NSIndexPath * path = [indexs objectAtIndex:0];
        NSString * day = [[cache allDays] objectAtIndex:path.section];
        return [Utils parseNSStringDay:day];

    } else {
        return  nil;
    }
}

#pragma mark -
#pragma mark tableViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self changeCalOnDisplayDay];
}

- (void)changeCalOnDisplayDay
{
    NSDate * date = [self getFirstVisibleDay];
    
    if(date != nil && self.feedEventdelegate != nil) {
        [self.feedEventdelegate onDisplayFirstDayChanged:date];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!decelerate) {
        [self changeCalOnDisplayDay];
    }
    int y = scrollView.contentOffset.y;
    
    if(y < 60) {
        NSArray * allDay = [cache allDays];
        if(allDay.count == 0) return;
        
        NSString* firtDay = [allDay objectAtIndex:0];
        
        NSLog(@"scrollViewDidScroll: load pre more events:%@", firtDay);
        
        NSDate * date = [Utils parseNSStringDay:firtDay];
        
        NSArray * dayFeedEntiys = [model getDayFeedEventEntitys:date andPreLimit:FETECH_DAYS andEventTypeFilter:self.eventTypeFilters];
        
        for(DayFeedEventEntitys * evt in dayFeedEntiys) {
            DayFeedEventEntitysWrap * wrap = [[DayFeedEventEntitysWrap alloc] init:evt];
            [cache putDayFeedEventEntitysWrap:wrap];
        }
        
        [self reloadData];
        
        [self performSelector:@selector(scroll2Date:) withObject:firtDay afterDelay:0.1];
        
        //[self scroll2Date:firtDay animated:NO];
        
    } else if( (y + scrollView.frame.size.height) + 60 > scrollView.contentSize.height) {
        
        NSArray * allDay = [cache allDays];
        if(allDay.count == 0) return;
        
        NSString* lastDay = [allDay lastObject];
        
        NSLog(@"scrollViewDidScroll: load pre more events:%@", lastDay);
        
        NSDate * date = [Utils parseNSStringDay:lastDay];
        
        NSArray * dayFeedEntiys = [model getDayFeedEventEntitys:date andFollowLimit:FETECH_DAYS andEventTypeFilter:self.eventTypeFilters];
        
        for(DayFeedEventEntitys * evt in dayFeedEntiys) {
            DayFeedEventEntitysWrap * wrap = [[DayFeedEventEntitysWrap alloc] init:evt];
            [cache putDayFeedEventEntitysWrap:wrap];
        }
        
        [self reloadData];
        
        [self performSelector:@selector(scroll2Date:) withObject:lastDay afterDelay:0.1];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSArray * allDay = [cache allDays];
    return allDay.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSArray * allDays = [cache allDays];
    NSString * day = [allDays objectAtIndex:section];
    DayFeedEventEntitysWrap * wrap = [cache getDayFeedEventEntitysWrap:day];
    if(wrap.eventTypeFilter != self.eventTypeFilters) {
        wrap.eventTypeFilter = self.eventTypeFilters;
        [wrap resetSortedEvents];
    }
   
    int count =  [wrap sortedEvents].count;
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSLog(@"cellForRowAtIndexPath:%@", indexPath);
    
    FeedEventEntity * event = [self getFeedEventEntity:indexPath];
    
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
    NSString * sectionName = [[cache allDays] objectAtIndex:section];
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


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"heightForRowAtIndexPath:%@", indexPath);
    
  
    FeedEventEntity * event = [self getFeedEventEntity:indexPath];
    
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

-(FeedEventEntity *) getFeedEventEntity:(NSIndexPath *)indexPath
{
    NSArray * allDays = [cache allDays];
    NSString * day = [allDays objectAtIndex:indexPath.section];
    DayFeedEventEntitysWrap * wrap = [cache getDayFeedEventEntitysWrap:day];

    if(wrap.eventTypeFilter != self.eventTypeFilters) {
        wrap.eventTypeFilter = self.eventTypeFilters;
        [wrap resetSortedEvents];
    }

    NSArray * events = [wrap sortedEvents];
    
    FeedEventEntity * event = [events objectAtIndex:indexPath.row];
    
    return event;
}


-(void) reloadFeedEventEntitys:(NSDate *) day
{
    [cache clearAllDayFeedEventEntitys];
    
    NSArray * feedEvents = [model getDayFeedEventEntitys:day andPreLimit:FETECH_DAYS andEventTypeFilter:self.eventTypeFilters];
    NSArray * feedEvents2 = [model getDayFeedEventEntitys:day andFollowLimit:FETECH_DAYS andEventTypeFilter:self.eventTypeFilters];
    
    NSMutableArray * array = [[NSMutableArray alloc] initWithArray:feedEvents];
    [array addObjectsFromArray:feedEvents2];
    
    for(DayFeedEventEntitys * evt in array) {
        DayFeedEventEntitysWrap * wrap = [[DayFeedEventEntitysWrap alloc] init:evt];
        [cache putDayFeedEventEntitysWrap:wrap];
    }
    
    [self reloadData];
}

-(void)scroll2SelectedDate:(NSString *) day {
    
    if( [cache containDay:day]) {
        [self scroll2Date:day animated:YES];
    } else {
        NSDate * date = [Utils parseNSStringDay:day];
        [self reloadFeedEventEntitys:date];
        [self scroll2Date:day animated:YES];
    }
}

-(void) scroll2Date:(NSString *) day
{
    [self scroll2Date:day animated:NO];
}

-(void) scroll2Date:(NSString *) day animated:(BOOL) animated
{
    NSArray * allDays = [cache allDays];
    
    if(allDays.count==0) return;
    
    int i = 0;
    for(;i<allDays.count;i++) {
        NSString * day1 = [allDays objectAtIndex:i];
        if([day1 compare:day]>=0) {
            break;
        }
    }
    
    if(i>=allDays.count) {
        i = allDays.count -1;
    }
    
    NSIndexPath * path = [NSIndexPath  indexPathForRow:0 inSection:i];
    [self scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:animated];
}

@end
