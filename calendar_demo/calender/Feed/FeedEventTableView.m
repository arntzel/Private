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
#import "UIColor+Hex.h"
#import "FeedEventTableViewCell.h"
#import <EventKit/EventKit.h>
#import "NoEventsCell.h"

#define FETECH_EVENTS 20
#define MAX_FORWARD 365
#define DAY (60*60*24)

#define HEADER_HEIGHT 28
#define NO_EVENTS_HEADER_CELL 31

#define TAG_SECTION_TEXT_LABEL 555
#define TAG_SECTION_TEXT_LABEL_LEFT 556


//一天的所有FeedEvent集合
@interface DayFeedEventEntitys : NSObject

@property NSString * day;

//FeedEventEntity array
@property NSMutableArray * events;

@end


@implementation DayFeedEventEntitys

-(id) init {
    self = [super init];
    self.events = [[NSMutableArray alloc] init];
    return  self;
}

@end




@interface FeedEventTableView() <UITableViewDataSource, UITableViewDelegate>

@end


@implementation FeedEventTableView {
    NSString * currentFirstDay;
    CoreDataModel * model;
   
    NSCalendar *gregorianCalendar;

    NSDate * firstVisibleDay;
    BOOL onDisplayFirstDayChangedNotify;
    
    
    NSDate *startDate;
    NSDate *endDate;
    NSMutableDictionary * dayFeedEventEntitysDic;

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
    onDisplayFirstDayChangedNotify = YES;
    
    gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [self registerNib:[UINib nibWithNibName:@"NoEventsCell" bundle:nil] forCellReuseIdentifier:@"NoEventsCell"];
    
    dayFeedEventEntitysDic = [[NSMutableDictionary alloc] init];
}

-(NSDate *) getFirstVisibleDay
{
    NSArray * indexs = [self indexPathsForVisibleRows];

    if(indexs.count > 0) {
        NSIndexPath * path = [indexs objectAtIndex:0];
        NSTimeInterval day = DAY;
        NSDate *sectionDate = [NSDate dateWithTimeInterval:day * path.section sinceDate:startDate];
        return sectionDate;

    } else {
        return  nil;
    }
}

#pragma mark -
#pragma mark tableViewDelegate

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
//    if(offsetY < 60) {
//        NSArray * allDay = [cache allDays];
//        if(allDay.count == 0) return;
//        
//        NSString* firtDay = [allDay objectAtIndex:0];
//        
//        NSLog(@"scrollViewDidScroll: load pre more events:%@, %d", cache.date, cache.preCount);
//
//        NSArray * feedEntiys = [model getDayFeedEventEntitys:cache.date andPreLimit:FETECH_EVENTS andOffset:cache.preCount andEventTypeFilter:self.eventTypeFilters];
//        
//        [cache putFeedEventEntitys:feedEntiys];
//        
//        cache.preCount += feedEntiys.count;
//
//        [self reloadData];
//        [self scroll2Date:firtDay];
//        [self flashScrollIndicators];
//    }
//    else
//    if( (offsetY + self.frame.size.height) + 60 > self.contentSize.height) {
//        
//        //NSArray * allDay = [cache allDays];
//        //if(allDay.count == 0) return;
//
//        NSLog(@"scrollViewDidScroll: load pre more events:%@，%d", cache.date, cache.followCount);
//
//        NSArray * feedEntiys = [model getDayFeedEventEntitys:cache.date andFollowLimit:FETECH_EVENTS andOffset:cache.followCount andEventTypeFilter:self.eventTypeFilters];
//        
//        [cache putFeedEventEntitys:feedEntiys];
//        cache.followCount += feedEntiys.count;
//        
//        [self reloadData];
//        [self flashScrollIndicators];
//    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (onDisplayFirstDayChangedNotify) {
                [self changeCalOnDisplayDay];
            }
        });
    });
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    onDisplayFirstDayChangedNotify = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSTimeInterval intreval = [endDate timeIntervalSinceDate:startDate];
    return (intreval / DAY);
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    UIView *s = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 22)];
//    [s setBackgroundColor:[UIColor whiteColor]];
//    return s;
    
    NSTimeInterval day = DAY;
    NSDate *sectionDate = [NSDate dateWithTimeInterval:day * section sinceDate:startDate];
    
    NSString *sectionNameKey = [Utils formateDay:sectionDate];
    
    UIView *viewSection = [ViewUtils createView:@"FeedEventHeader"];
    UILabel * dayLabel = (UILabel *)[viewSection viewWithTag:TAG_SECTION_TEXT_LABEL];
    dayLabel.text = [[Utils dayHeaderMiddle:sectionNameKey] uppercaseString];
    
    UILabel * dayLabelLeft = (UILabel *)[viewSection viewWithTag:TAG_SECTION_TEXT_LABEL_LEFT];
    dayLabelLeft.text = [[Utils dayHeaderLeft:sectionNameKey] uppercaseString];
    
    //CALayer *layerTop = [CALayer layer];
    //layerTop.frame = CGRectMake(0, 0, 320, 0.5f);
    //layer.backgroundColor = [UIColor generateUIColorByHexString:@"#d1d9d2" withAlpha:0.8].CGColor;
    //layerTop.backgroundColor = [UIColor lightGrayColor].CGColor;
    //[viewSection.layer addSublayer:layerTop];

    CALayer *layerBottom = [CALayer layer];
    layerBottom.frame = CGRectMake(0, HEADER_HEIGHT - 0.5f, 320, 0.5f);
    //layer.backgroundColor = [UIColor generateUIColorByHexString:@"#d1d9d2" withAlpha:0.8].CGColor;
    layerBottom.backgroundColor = [UIColor lightGrayColor].CGColor;
    [viewSection.layer addSublayer:layerBottom];
    
    return viewSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSDate *sectionDate = [NSDate dateWithTimeInterval:DAY * section sinceDate:startDate];
    NSString *sectionName = [Utils formateDay:sectionDate];
   
    DayFeedEventEntitys * dayEvents = [dayFeedEventEntitysDic objectForKey:sectionName];
   
    if(dayEvents == nil || dayEvents.events.count == 0) {
        return 1; //No event cell
    } else {
        return  dayEvents.events.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    NSDate * sectionDate = [NSDate dateWithTimeInterval:DAY * section sinceDate:startDate];
    NSString * sectionName = [Utils formateDay:sectionDate];

    DayFeedEventEntitys * dayEvents = [dayFeedEventEntitysDic objectForKey:sectionName];
    
    if(dayEvents == nil || dayEvents.events.count == 0) {
        
        NoEventsCell *c = (NoEventsCell*)[tableView dequeueReusableCellWithIdentifier:@"NoEventsCell"];
        return c;
        
    } else {
        
        int row = indexPath.row;
        
        BOOL lastForThisDay = (row == (dayEvents.events.count-1));
        
        FeedEventEntity * event = [dayEvents.events objectAtIndex:row];
    
        if( ![event isBirthdayEvent])
        {
            UITableViewCell * cell = [self dequeueReusableCellWithIdentifier:@"eventView"];
            EventView * view;
            if(cell == nil) {
                view = [EventView createEventView];
                view.tag = 1;
                cell = [[FeedEventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eventView"];
                [cell addSubview:view];
            } else {
                view = (EventView*)[cell viewWithTag:1];
            }
            
            [view refreshView:event lastForThisDay:lastForThisDay];
            
            //[cell setBackgroundColor:[UIColor clearColor]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        else
        {
            UITableViewCell * cell = [self dequeueReusableCellWithIdentifier:@"birthdayEventView"];
            BirthdayEventView * view;
            if(cell == nil) {
                view = [BirthdayEventView createEventView];
                view.tag = 2;
                cell = [[FeedEventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"birthdayEventView"];
                [cell addSubview:view];
            } else {
                view = (BirthdayEventView*)[cell viewWithTag:2];
            }
            [view refreshView:event];
            
            //[cell setBackgroundColor:[UIColor clearColor]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADER_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    int section = indexPath.section;
    NSDate *sectionDate = [NSDate dateWithTimeInterval:DAY * section sinceDate:startDate];
    NSString *sectionName = [Utils formateDay:sectionDate];
    
    DayFeedEventEntitys * dayEvents = [dayFeedEventEntitysDic objectForKey:sectionName];
    
    if(dayEvents == nil || dayEvents.events.count == 0) {
        return NO_EVENTS_HEADER_CELL; //No event cell
    } else {
        
        int row = indexPath.row;
        
        FeedEventEntity * event = [dayEvents.events objectAtIndex:row];

        if ([event isBirthdayEvent] ) {
            return BirthdayEventView_Height;
        }
        else {
            //NSString *eventTitle = event.title;
#if 0
            CGSize maxSize = CGSizeMake(270.0, 1000.0f);
            UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:16];
            CGSize fontSize = [event.title sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
            return fontSize.height + 85;
#endif
            return 87;//76;//87;
        }

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LOG_D(@"tableView:didSelectRowAtIndexPath:%@", indexPath);
    
    int section = indexPath.section;
    NSDate *sectionDate = [NSDate dateWithTimeInterval:DAY * section sinceDate:startDate];
    NSString *sectionName = [Utils formateDay:sectionDate];
    
    DayFeedEventEntitys * dayEvents = [dayFeedEventEntitysDic objectForKey:sectionName];
    
    if(dayEvents == nil || dayEvents.events.count == 0) {
        return; //No event cell
    } else {
        
        int row = indexPath.row;
        
        FeedEventEntity * event = [dayEvents.events objectAtIndex:row];

        if([event.eventType intValue]== 0) {
            
            EventDetailController * detailCtl = [[EventDetailController alloc] init];
            detailCtl.popDelegate = self.popDelegate;
            detailCtl.eventID = [event.id intValue];
            [[RootNavContrller defaultInstance] pushViewController:detailCtl animated:YES];
        }
    }
}



-(void) reloadFeedEventEntitys:(NSDate *) day
{
    startDate = [day cc_dateByMovingToBeginningOfDay];
    endDate = [startDate cc_dateByMovingToTheFollowingDayCout:14];
    
    [dayFeedEventEntitysDic removeAllObjects];
    
    NSArray * feedEvents = [model getDayFeedEventEntitys:startDate andEndDate:endDate];
    
    for (FeedEventEntity * entity in feedEvents) {
        NSString * day = [Utils formateDay:entity.start];
        DayFeedEventEntitys * dayEntity = [dayFeedEventEntitysDic objectForKey:day];
        
        if(dayEntity == nil) {
            dayEntity = [[DayFeedEventEntitys alloc] init];
            [dayFeedEventEntitysDic setObject:dayEntity forKey:day];
            dayEntity.day = day;
            [dayEntity.events addObject:entity];
        } else {
            [dayEntity.events addObject:entity];
        }
    }
    
    [self reloadData];
}

-(void)scroll2SelectedDate:(NSString *) day {
    
    if ([self isDecelerating]) {
        return;
    }
    
    onDisplayFirstDayChangedNotify = NO;

    [self scroll2Date:day animated:YES];
}

-(void) scroll2Date:(NSString *) day
{
    [self scroll2Date:day animated:NO];
}

-(void) scroll2Date:(NSString *) day1 animated:(BOOL) animated
{
    for (int i=0; i < MAX_FORWARD; i++) {
        NSTimeInterval day = 60*60*24;
        NSDate *sectionDate = [NSDate dateWithTimeInterval:day * i sinceDate:startDate];
        NSString *sectionName = [Utils formateDay:sectionDate];
        if ([sectionName isEqualToString:day1]) {
            
            NSIndexPath * path = [NSIndexPath  indexPathForRow:0 inSection:i];

            [self scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:animated];

            return;
        }
    }
}

- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate
{
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:inputDate];
    // Set the time components manually
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    // Convert back
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
}

- (NSDate *)dateByAddingYears:(NSInteger)numberOfYears toDate:(NSDate *)inputDate
{
    // Use the user's current calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setYear:numberOfYears];
    NSDate *newDate = [calendar dateByAddingComponents:dateComps toDate:inputDate options:0];
    return newDate;
}

- (void)scrollViewDidEndDragging000:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    if (!decelerate) {
    //        [self changeCalOnDisplayDay];
    //    }
    
    
    //YKTEMP:
    //    int y = scrollView.contentOffset.y;
    //    if (!decelerate) {
    //        [self reloadMoreData:y];
    //    }
    
    
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

@end
