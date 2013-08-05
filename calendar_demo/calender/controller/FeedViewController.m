
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
#import "CoreDataModel.h"

/*
 FeedViewController show the event list and a calender wiget
 */
@interface FeedViewController () <UITableViewDataSource,
                                  UITableViewDelegate,
                                  KalViewDelegate,
                                  KalTileViewDataSource,
                                  EventFilterViewDelegate,
                                  EventModelDelegate,
                                  FeedEventTableViewDelegate>
{
    KalLogic *logic;
    FeedCalenderView *calendarView;
    FeedEventTableView * tableView;
   
    CustomerIndicatorView * dataLoadingView;
}

@property (nonatomic, retain) FeedCalenderView *calendarView;

@end

@implementation FeedViewController

@synthesize calendarView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self.navigation.rightBtn addTarget:self action:@selector(btnAddEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    int y = self.navigation.frame.size.height;

    CGRect frame = self.view.bounds;
    frame.origin.y = y;
    frame.size.height -=(y + 64);
    
    
    tableView = [[FeedEventTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    tableView.feedEventdelegate = self;
    
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
        tableView.eventTypeFilters = filetVal;
    } else {
        int filetVal = FILTER_BIRTHDAY | FILTER_FB | FILTER_IMCOMPLETE | FILTER_GOOGLE;
        [self.calendarView.filterView setFilter:filetVal];
        tableView.eventTypeFilters = filetVal;
    }
    
    self.calendarView.filterView.delegate = self;

    dataLoadingView = [[CustomerIndicatorView alloc] init];
    frame = dataLoadingView.frame;
    frame.origin.x = 320 + 40;
    frame.origin.y = 55;
    dataLoadingView.frame = frame;
    

    [self.view addSubview:dataLoadingView];
    //[tableView startTailerLoading];

    NSDate * begin = [NSDate date];
    //begin = [begin cc_dateByMovingToFirstDayOfThePreviousMonth];
    tableView.beginDate = begin;
    //[self loadData:begin];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void) loadData:(NSDate *) begin
{
    NSLog(@"loadData begin:%@", begin);
    
    [[Model getInstance] getEventsOfBegin:begin andEnd:nil andCallback:^(NSInteger error, NSArray *events) {

        LOG_D(@"getEvents:error=%d, events size=%d", error, events.count);

        if(error == 0) {

            CoreDataModel * model = [CoreDataModel getInstance];

            for(Event * evt in events) {
                FeedEventEntity * entity = [model createEntity:@"FeedEventEntity"];
                [entity convertFromEvent:evt];
                [model addFeedEventEntity:entity];
            }

            [model saveData];

            [tableView reloadData];

        } else {
            [Utils showUIAlertView:@"Error" andMessage:@"Network or server error"];
        }
    }];
}


#pragma mark -
#pragma mark kalViewDelegate

- (void)didSelectDate:(KalDate *)date
{

    NSDate * selectDate = [date NSDate];

    int day = [tableView.beginDate cc_DaysBetween:selectDate];
    if(day<0) {
        day = 0;
    }

    NSIndexPath * path = [NSIndexPath  indexPathForRow:0 inSection:day];
    [tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (self.view.frame.origin.x > 100) {
        return NO;
    }
    return YES;
}


#pragma mark -
#pragma mark KalTileViewDataSource
-(int) getEventType:(KalDate *) date
{     
    NSString * day = [Utils formateDay:[date NSDate]];
    int type =[[CoreDataModel getInstance] getDayFeedEventType:day];
    type = type & tableView.eventTypeFilters;
    return type;
}


#pragma mark -
#pragma mark EventFilterViewDelegate
-(void) onFilterChanged:(int)filters
{
    LOG_D(@"onFilterChanged:0x %x", filters);

    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject: [NSNumber numberWithInt:filters] forKey:@"eventfilters"];
    [defaults synchronize];

    tableView.eventTypeFilters = filters;
    [self.calendarView setNeedsDisplay];
    [tableView reloadData];
}

//#pragma mark -
//#pragma mark AddEventViewDelegate
//-(void) onEventCreated:(Event *) event
//{
//    [eventModel addNewEvent:event];
//    [tableView reloadData];
//}

-(void) onEventModelChanged {
    [tableView reloadData];
    [self.calendarView setNeedsDisplay];
}


#pragma mark -
#pragma mark FeedEventTableViewDelegate
-(void) onDisplayFirstDayChanged:(NSDate *) firstDay
{
    NSLog(@"onDisplayFirstDayChanged:%@", firstDay);
    [self.calendarView.kalView swith2Date:firstDay];
}
@end
