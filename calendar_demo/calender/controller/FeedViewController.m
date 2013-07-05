
#import "FeedViewController.h"


#import "EventView.h"

#import "Location.h"

#import "KalLogic.h"
#import "KalDate.h"
#import "NSDateAdditions.h"

#import "UserModel.h"
#import "Model.h"
#import "Utils.h"

#import "RootNavContrller.h"
#import "AddEventViewController.h"

#import "EventModel.h"

#import "FeedEventTableView.h"

#import "FeedCalenderView.h"

/*
 FeedViewController show the event list and a calender wiget
 */
@interface FeedViewController () <UITableViewDataSource,
                                  UITableViewDelegate,
                                  PullRefreshTableViewDelegate,
                                  KalViewDelegate,
                                  KalTileViewDataSource>
{
    KalLogic *logic;
    FeedCalenderView *calendarView;
    FeedEventTableView * tableView;
   
    EventModel * eventModel;
    
    int selectedYear;
    int selectedMonth;
    int selectedDay;
}

@property (nonatomic, retain) FeedCalenderView *calendarView;
@end

@implementation FeedViewController

@synthesize calendarView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    eventModel = [[Model getInstance] getEventModel];
   
    [self.navigation.rightBtn addTarget:self action:@selector(btnAddEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    int y = self.navigation.frame.size.height;

    CGRect frame = self.view.bounds;
    frame.origin.y = y;
    frame.size.height -=(y + 64);
    
    
    tableView = [[FeedEventTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;



    tableView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    [tableView setAllowsSelection:NO];
    tableView.headerEnabled = YES;
    tableView.tailerEnabled = NO;
    tableView.pullRefreshDalegate = self;
    
    [self.view addSubview:tableView];
    

    
    NSDate *date = [NSDate date];
    logic = [[KalLogic alloc] initForDate:date];
    
    self.calendarView = [[FeedCalenderView alloc] initWithdelegate:self logic:logic selectedDate:[KalDate dateFromNSDate:date]];
    [self.calendarView setUserInteractionEnabled:YES];
    [self.calendarView setMultipleTouchEnabled:YES];
    [self.calendarView setKalTileViewDataSource:self];
    [self.view addSubview:self.calendarView];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];
    selectedYear = [components year];  //当前的年份
    selectedMonth = [components month];  //当前的月份
    selectedDay = [components day];

    [tableView startHeaderLoading];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}


-(void) loadData:(int) year andMonth:(int)month
{
    
    [[Model getInstance] getEvents:year andMonth:month andCallback:^(NSInteger error, NSArray *events) {
        
        NSLog(@"getEvents:error=%d, events size=%d", error, events.count);
        
        if(error == 0) {
    
            NSString * strMonth = [Utils formate:year andMonth:month];
            [eventModel setEvents:events forMonth:strMonth];

            [tableView setEventModel:eventModel];
            [self.calendarView setNeedsDisplay];
            
        } else {
            //TODO:: show network error
        }

        [tableView stopPullLoading];
    }];
}


#pragma mark -
#pragma mark btnEvent
- (void)btnAddEvent:(id)sender
{
    AddEventViewController *addEvent = [[AddEventViewController alloc] initWithNibName:@"AddEventViewController" bundle:nil];
    [[RootNavContrller defaultInstance] pushViewController:addEvent animated:YES];
}


#pragma mark -
#pragma mark kalViewDelegate

- (void)didSelectDate:(KalDate *)date
{
    if([tableView isLoading]) {
        return;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents *components = [calendar components:unitFlags fromDate:[date NSDate]];
    
    selectedYear = [components year];
    selectedMonth = [components month];
    selectedDay = [components day];
    
    NSString * strmonth = [Utils formate:selectedYear andMonth:selectedMonth];
    
    if([eventModel getEventsByMonth:strmonth] == nil) {

        [tableView startHeaderLoading];
        
    } else {
        [self tableviewScroll2SelectDay];
    }
}

-(void) tableviewScroll2SelectDay {
    
    NSString * selectedDate = [Utils formate:selectedYear andMonth:selectedMonth andDay:selectedDay];
    
    NSLog(@"tableviewScroll2SelectDay:%@", selectedDate);
    
    NSArray * array = [eventModel getAllDays];
    
    if(array.count ==0 ) return;
    
    int index = 0;
    for(; index<array.count; index++) {
        NSString * day = [array objectAtIndex:index];
        if( [selectedDate compare:day] >= 0 ) {
            break;
        }
    }
    
    if(index == array.count) {
        index--;
    }
    
    NSIndexPath * path = [NSIndexPath  indexPathForRow:0 inSection:index];
    [tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark -
#pragma mark KalTileViewDataSource
-(int) getEventType:(KalDate *) date {

    NSString * day = [Utils formate:date.year andMonth:date.month andDay:date.day];

    int eventTypes = [eventModel getEventsTypes:day];
    return eventTypes;
}



#pragma mark -
#pragma mark PullRefreshTableViewDelegate
- (void) onPullStarted {

}

- (void) onPullCancelled {

}

-(void) onStartLoadData
{
    [self loadData:selectedYear andMonth:selectedMonth];
}
@end
