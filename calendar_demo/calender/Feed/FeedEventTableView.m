
#import "FeedEventTableView.h"
#import "Event.h"
#import "EventView.h"
#import "BirthdayEventView.h"
#import "Utils.h"
#import "ViewUtils.h"

#import "EventDetailController.h"

#import "RootNavContrller.h"
#import "NSDateAdditions.h"
#import "CoreDataModel.h"
#import "FeedEventEntity.h"

#define FETECH_EVENTS 5

@interface FeedEventTableView() <UITableViewDataSource, UITableViewDelegate>

@end


@implementation FeedEventTableView {
    NSString * currentFirstDay;
    CoreDataModel * model;
    DataCache * cache;

    NSDate * firstVisibleDay;
    BOOL onDisplayFirstDayChangedNotify;
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
    onDisplayFirstDayChangedNotify = YES;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(onDisplayFirstDayChangedNotify) {
        [self changeCalOnDisplayDay];
    }
}

- (void)changeCalOnDisplayDay
{
    NSDate * date = [self getFirstVisibleDay];

    if( [self isFirstVisibleDayChanged:date] ) {
        if(date != nil && self.feedEventdelegate != nil) {
            [self.feedEventdelegate onDisplayFirstDayChanged:date];
        }

        firstVisibleDay = date;
    }    
}

-(BOOL) isFirstVisibleDayChanged:(NSDate *) date
{
    if(firstVisibleDay == nil && date == nil) {
        return NO;
    }

    if(firstVisibleDay==nil || date == nil) {
        return YES;
    }

    NSString * day1 = [Utils formateDay:firstVisibleDay];
    NSString * day2 = [Utils formateDay:date];

    return ![day1 isEqualToString:day2];
}

- (void)reloadMoreData:(NSInteger)offsetY
{
    if(offsetY < 60) {
        NSArray * allDay = [cache allDays];
        if(allDay.count == 0) return;
        
        NSString* firtDay = [allDay objectAtIndex:0];
        
        NSLog(@"scrollViewDidScroll: load pre more events:%@, %d", cache.date, cache.preCount);

        NSArray * feedEntiys = [model getDayFeedEventEntitys:cache.date andPreLimit:FETECH_EVENTS andOffset:cache.preCount andEventTypeFilter:self.eventTypeFilters];
        
        [cache putFeedEventEntitys:feedEntiys];
        cache.preCount += feedEntiys.count;

        [self reloadData];
        [self scroll2Date:firtDay];
        [self flashScrollIndicators];
        
        
    } else if( (offsetY + self.frame.size.height) + 60 > self.contentSize.height) {
        
        //NSArray * allDay = [cache allDays];
        //if(allDay.count == 0) return;

        NSLog(@"scrollViewDidScroll: load pre more events:%@，%d", cache.date, cache.followCount);
        

        NSArray * feedEntiys = [model getDayFeedEventEntitys:cache.date andFollowLimit:FETECH_EVENTS andOffset:cache.followCount andEventTypeFilter:self.eventTypeFilters];
        
        [cache putFeedEventEntitys:feedEntiys];
        cache.followCount += feedEntiys.count;
        
        [self reloadData];
        [self flashScrollIndicators];

    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int y = scrollView.contentOffset.y;
    [self reloadMoreData:y];
    onDisplayFirstDayChangedNotify = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    
//    if (!decelerate) {
//        [self changeCalOnDisplayDay];
//    }
    int y = scrollView.contentOffset.y;
    if (!decelerate) {
        [self reloadMoreData:y];
    }
    
    
//    if(y < 60) {
//        NSArray * allDay = [cache allDays];
//        if(allDay.count == 0) return;
//        
//        NSString* firtDay = [allDay objectAtIndex:0];
//        
//        NSLog(@"scrollViewDidScroll: load pre more events:%@", firtDay);
//        
//        NSDate * date = [Utils parseNSStringDay:firtDay];
//        
//        NSArray * dayFeedEntiys = [model getDayFeedEventEntitys:date andPreLimit:FETECH_DAYS andEventTypeFilter:self.eventTypeFilters];
//        
//        for(DayFeedEventEntitys * evt in dayFeedEntiys) {
//            DayFeedEventEntitysWrap * wrap = [[DayFeedEventEntitysWrap alloc] init:evt];
//            [cache putDayFeedEventEntitysWrap:wrap];
//        }
//        
//        [self reloadData];
//        
//        [self performSelector:@selector(scroll2Date:) withObject:firtDay afterDelay:0.1];
//        //[self scroll2Date:firtDay animated:NO];
//        
//    } else if( (y + scrollView.frame.size.height) + 60 > scrollView.contentSize.height) {
//        
//        NSArray * allDay = [cache allDays];
//        if(allDay.count == 0) return;
//        
//        NSString* lastDay = [allDay lastObject];
//        
//        NSLog(@"scrollViewDidScroll: load pre more events:%@", lastDay);
//        
//        NSDate * date = [Utils parseNSStringDay:lastDay];
//        
//        NSArray * dayFeedEntiys = [model getDayFeedEventEntitys:date andFollowLimit:FETECH_DAYS andEventTypeFilter:self.eventTypeFilters];
//        
//        for(DayFeedEventEntitys * evt in dayFeedEntiys) {
//            DayFeedEventEntitysWrap * wrap = [[DayFeedEventEntitysWrap alloc] init:evt];
//            [cache putDayFeedEventEntitysWrap:wrap];
//        }
//        
//        [self reloadData];
//        
//        //[self performSelector:@selector(scroll2Date:) withObject:lastDay afterDelay:0.1];
//    }
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
    FeedEventEntity * event = [self getFeedEventEntity:indexPath];
    
    if([event.eventType intValue] != 4) {

        UITableViewCell * cell = [self dequeueReusableCellWithIdentifier:@"eventView"];
        EventView * view;
        if(cell == nil) {
            view = [EventView createEventView];
            view.tag = 1;
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eventView"];
            [cell addSubview:view];
        } else {
            view = (EventView*)[cell viewWithTag:1];
        }

        [view refreshView:event];

        return cell;

    } else {

        UITableViewCell * cell = [self dequeueReusableCellWithIdentifier:@"birthdayEventView"];
        BirthdayEventView * view;
        if(cell == nil) {
            view = [BirthdayEventView createEventView];
            view.tag = 2;
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"birthdayEventView"];
            [cell addSubview:view];
        } else {
            view = (BirthdayEventView*)[cell viewWithTag:2];
        }

        [view refreshView:event];
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

    FeedEventEntity * event = [self getFeedEventEntity:indexPath];
    EventDetailController * detailCtl = [[EventDetailController alloc] init];
    detailCtl.eventID = [event.id intValue];
    
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
    cache.date = day;
    cache.preCount = 0;
    cache.followCount = 0;


    NSArray * feedEvents = [model getDayFeedEventEntitys:cache.date andPreLimit:FETECH_EVENTS andOffset:0 andEventTypeFilter:self.eventTypeFilters];
    [cache putFeedEventEntitys:feedEvents];
    cache.preCount += feedEvents.count;

    NSArray * feedEvents2 = [model getDayFeedEventEntitys:cache.date andFollowLimit:FETECH_EVENTS andOffset:0 andEventTypeFilter:self.eventTypeFilters];
    [cache putFeedEventEntitys:feedEvents2];
    cache.followCount += feedEvents2.count;
    
    [self reloadData];
}

-(void)scroll2SelectedDate:(NSString *) day {
    
    if([self isDecelerating]) {
        return;
    }
    
    onDisplayFirstDayChangedNotify = NO;
    
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
    if (i > 0) {
        [self scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:animated];
    }
    
}

@end
