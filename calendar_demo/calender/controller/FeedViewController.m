
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

#import "EventDetailViewController.h"
#import "CustomerIndicatorView.h"
#import "NSDateAdditions.h"

/*
 FeedViewController show the event list and a calender wiget
 */
@interface FeedViewController () <UITableViewDataSource,
                                  UITableViewDelegate,
                                  PullRefreshTableViewDelegate,
                                  KalViewDelegate,
                                  KalTileViewDataSource,
                                  EventFilterViewDelegate,
                                  AddEventViewDelegate>
{
    KalLogic *logic;
    FeedCalenderView *calendarView;
    FeedEventTableView * tableView;
   
    EventModel * eventModel;

    CustomerIndicatorView * dataLoadingView;
}

@property (nonatomic, retain) FeedCalenderView *calendarView;

@end

@implementation FeedViewController

@synthesize calendarView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    eventModel = [[Model getInstance] getEventModel];
    eventModel.begin = eventModel.end = [NSDate date];


    [self.navigation.rightBtn addTarget:self action:@selector(btnAddEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    int y = self.navigation.frame.size.height;

    CGRect frame = self.view.bounds;
    frame.origin.y = y;
    frame.size.height -=(y + 64);
    
    
    tableView = [[FeedEventTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    //[tableView setAllowsSelection:NO];
    
    tableView.headerEnabled = YES;
    tableView.tailerEnabled = YES;
    tableView.pullRefreshDalegate = self;
    
    [self.view addSubview:tableView];
    

    
    NSDate *date = [NSDate date];
    logic = [[KalLogic alloc] initForDate:date];
    
    self.calendarView = [[FeedCalenderView alloc] initWithdelegate:self logic:logic selectedDate:[KalDate dateFromNSDate:date]];
    [self.calendarView setUserInteractionEnabled:YES];
    [self.calendarView setMultipleTouchEnabled:YES];
    [self.calendarView setKalTileViewDataSource:self];
    [self.view addSubview:self.calendarView];


    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSNumber * filterNum = [defaults objectForKey:@"eventfilters"];
    if(filterNum != nil) {
        int filetVal = filterNum.intValue;
        LOG_D(@"Read filterVal:0x %x", filetVal);
        [self.calendarView.filterView setFilter: filetVal];
        [eventModel setFilter:filetVal];
    } else {
        int filetVal = FILTER_BIRTHDAY | FILTER_FB | FILTER_IMCOMPLETE | FILTER_GOOGLE;
        [self.calendarView.filterView setFilter:filetVal];
        [eventModel setFilter:filetVal];
    }
    
    self.calendarView.filterView.delegate = self;

//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
//    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];
//    selectedYear = [components year];  //当前的年份
//    selectedMonth = [components month];  //当前的月份
//    selectedDay = [components day];

    dataLoadingView = [[CustomerIndicatorView alloc] init];
    frame = dataLoadingView.frame;
    frame.origin.x = 320 + 40;
    frame.origin.y = 55;
    dataLoadingView.frame = frame;
    

    [self.view addSubview:dataLoadingView];
    [tableView startTailerLoading];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}


-(void) loadDataBegin:(NSDate *) begin andEnd:(NSDate *)end
{

    [[Model getInstance] getEventsOfBegin:begin andEnd:end andCallback:^(NSInteger error, NSArray *events) {

        LOG_D(@"getEvents:error=%d, events size=%d", error, events.count);

        if(error == 0) {

            [eventModel addEvents:events];

            if([begin compare:eventModel.begin] < 0) {
                eventModel.begin = begin;
            }

            if([end compare:eventModel.end] > 0) {
                eventModel.end = end;
            }

            [tableView setEventModel:eventModel];
            [self.calendarView setNeedsDisplay];

        } else {
            //TODO:: show network error
        }

        [tableView stopPullLoading];
    }];    
}



#pragma mark -
#pragma mark kalViewDelegate

- (void)didSelectDate:(KalDate *)date
{
    NSString * selectedDate = [Utils formateDay:[date NSDate]];
    [self tableviewScroll2SelectDay:selectedDate];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (self.view.frame.origin.x > 100) {
        return NO;
    }
    return YES;
}

-(void) tableviewScroll2SelectDay:(NSString *) selectedDate
{
    
    //NSString * selectedDate = [Utils formate:selectedYear andMonth:selectedMonth andDay:selectedDay];
    
    LOG_D(@"tableviewScroll2SelectDay:%@", selectedDate);
    
    NSArray * array = [eventModel getAllDays];
    
    if(array.count ==0 ) return;
    
    int index = 0;
    for(; index<array.count; index++) {
        NSString * day = [array objectAtIndex:index];
        if( [selectedDate compare:day] <= 0 ) {
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

-(void) onPullStop {
    
    [dataLoadingView stopAnim];
}

- (void) onPullCancelled {

}

-(void) onStartLoadData:(BOOL)head
{
    if(head) {

        NSDate * end = eventModel.begin;
        NSDate * begin = [end cc_dateByMovingToThePreviousDayCout:7];
        [self loadDataBegin:begin andEnd:end];
        
    } else {

        NSDate * begin = eventModel.end;
        NSDate * end = [begin cc_dateByMovingToTheFollowingDayCout:7];
        [self loadDataBegin:begin andEnd:end];
    }

    [dataLoadingView startAnim];
}


#pragma mark -
#pragma mark EventFilterViewDelegate
-(void) onFilterChanged:(int)filters
{
    LOG_D(@"onFilterChanged:0x %x", filters);

    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject: [NSNumber numberWithInt:filters] forKey:@"eventfilters"];
    [defaults synchronize];

    [eventModel setFilter:filters];
    [tableView reloadData];
}

#pragma mark -
#pragma mark AddEventViewDelegate
-(void) onEventCreated:(Event *) event
{
    [eventModel addNewEvent:event];
    [tableView reloadData];
}

@end
