
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


#import "FeedEventTableView.h"

#import "FeedCalenderView.h"

#import "CustomerIndicatorView.h"
#import "NSDateAdditions.h"
#import "CoreDataModel.h"
#import "LoadingProgressView.h"
#import "ViewUtils.h"
#import "EventModel.h"

#import "SignupViewController.h"

#import "UserSetting.h"

/*
 FeedViewController show the event list and a calender wiget
 */
@interface FeedViewController () <KalViewDelegate,
                                  KalTileViewDataSource,
                                  EventFilterViewDelegate,
                                  FeedEventTableViewDelegate,
                                  CoreDataModelDelegate,
                                  EventModelDelegate,
                                  UIAlertViewDelegate >
{
    KalLogic *logic;
    FeedCalenderView *calendarView;
    FeedEventTableView * tableView;
   
    CustomerIndicatorView * dataLoadingView;
    
    LoadingProgressView * loadingPrigressView;
    
    int synchronzieEventOffset;
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

    int filters = [[UserSetting getInstance] getEventfilters];
    LOG_D(@"Read filterVal:0x %x", filters);
    [self.calendarView.filterView setFilter:filters];
    tableView.eventTypeFilters = filters;
    
    self.calendarView.filterView.delegate = self;

    dataLoadingView = [[CustomerIndicatorView alloc] init];
    frame = dataLoadingView.frame;
    frame.origin.x = 320 + 40;
    frame.origin.y = 55;
    dataLoadingView.frame = frame;
   
    [self.view addSubview:dataLoadingView];
    
    
    NSDate * lastupdatetime =  [[UserSetting getInstance] getLastUpdatedTime];
    
    if(lastupdatetime == nil) {
               
        loadingPrigressView = (LoadingProgressView*)[ViewUtils createView:@"LoadingProgressView"];
        loadingPrigressView.progressView.progress = 0;
        loadingPrigressView.center = self.view.center;
        [self.view addSubview:loadingPrigressView];

        NSDate * begin = [NSDate date];
        begin = [begin cc_dateByMovingToFirstDayOfThePreviousMonth];

        [[[Model getInstance] getEventModel] setSynchronizeData:YES];
        
        synchronzieEventOffset = 0;
        [self synchronFeedEventFromServer:synchronzieEventOffset andBeginDate:begin];
        
    } else {
        tableView.lastEventUpdateTime = lastupdatetime;
        [tableView reloadFeedEventEntitys:[NSDate date]];
        [self scroll2Today];
    }
    
    [[CoreDataModel getInstance] addDelegate:self];
    [[[Model getInstance] getEventModel] addDelegate:self];
}

-(void)viewDidUnload {
    [[CoreDataModel getInstance] removeDelegate:self];
    [[[Model getInstance] getEventModel] removeDelegate:self];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}


-(void) synchronFeedEventFromServer: (int) offset andBeginDate:(NSDate *) begin
{
       
    [[Model getInstance] getEventsOfBegin:begin andOffset:offset andCallback:^(NSInteger error, NSInteger count, NSArray *events) {
        
        LOG_D(@"getEvents:error=%d, events size=%d, allcount=%d", error, events.count, count);
        
        if(error == 0) {
            
            if(events.count > 0) {
                CoreDataModel * model = [CoreDataModel getInstance];
                
                for(Event * evt in events) {
                    FeedEventEntity * entity = [model createEntity:@"FeedEventEntity"];
                    [entity convertFromEvent:evt];
                    [model addFeedEventEntity:entity];
                }
                
                [model saveData];
            }
            
            //Load event compeleted
            if(events.count < 50) {


                [loadingPrigressView removeFromSuperview];
                loadingPrigressView = nil;

                [[[Model getInstance] getEventModel] setSynchronizeData:NO];

                
                [tableView reloadFeedEventEntitys:[NSDate date]];
                [self.calendarView setNeedsDisplay];
                
                [self scroll2Today];
                
                [[UserSetting getInstance] saveLastUpdatedTime:[NSDate date]];
                
            } else {
                
                synchronzieEventOffset = (offset + events.count);
                float progress = synchronzieEventOffset / (float)count;
                loadingPrigressView.progressView.progress = progress;
                
                [self synchronFeedEventFromServer: synchronzieEventOffset andBeginDate:begin];
            }
            
                        
        } else {
            
            [dataLoadingView stopAnim];
            
            
            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                          message:@"Network or server error"
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Retry",nil];
            [alert show];            
        }
    }];
}

/*
-(void) loadData:(NSDate *) begin
{
    NSLog(@"loadData begin:%@", begin);
    
    [dataLoadingView startAnim];
    
    [[Model getInstance] getEventsOfBegin:begin andEnd:nil andCallback:^(NSInteger error, NSArray *events) {

        LOG_D(@"getEvents:error=%d, events size=%d", error, events.count);

        [dataLoadingView stopAnim];
      
        
        if(error == 0) {

            CoreDataModel * model = [CoreDataModel getInstance];

            for(Event * evt in events) {
                FeedEventEntity * entity = [model createEntity:@"FeedEventEntity"];
                [entity convertFromEvent:evt];
                [model addFeedEventEntity:entity];
            }

            [model saveData];

            [tableView reloadFeedEventEntitys:[NSDate date]];
            [self.calendarView setNeedsDisplay];
            
            [self scroll2Today];
            
            [[UserSetting getInstance] saveLastUpdatedTime:[NSDate date]];
            
        } else {
            [Utils showUIAlertView:@"Error" andMessage:@"Network or server error"];
        }
    }];
}
*/

-(void) scroll2Today
{
    [self scroll2Date:[NSDate date] animated:NO];
}

-(void) scroll2Date:(NSDate *) date animated:(BOOL) animated
{
    NSString * day = [Utils formateDay:date];
    [tableView scroll2Date:day animated:NO];
}

#pragma mark -
#pragma mark kalViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        
        [[UserModel getInstance] setLoginUser:nil];
        [[UserSetting getInstance] reset];
        [[CoreDataModel getInstance] reset];
        
        RootNavContrller *navController = [RootNavContrller defaultInstance];
        [navController popToRootViewControllerAnimated:NO];
        
        SignupViewController* rootController = [[SignupViewController alloc] init];
        [navController pushViewController:rootController animated:NO];
        
    } else {
        NSDate * begin = [NSDate date];
        begin = [begin cc_dateByMovingToFirstDayOfThePreviousMonth];
        
        [[[Model getInstance] getEventModel] setSynchronizeData:YES];
        [self synchronFeedEventFromServer:synchronzieEventOffset andBeginDate:begin];
    }
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark kalViewDelegate

- (void)didSelectDate:(KalDate *)date
{
    NSDate * selectDate = [date NSDate];
    NSString * day = [Utils formateDay:selectDate];
    [tableView scroll2SelectedDate:day];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (self.view.frame.origin.x > 100) {
        return NO;
    }
    return YES;
}


#pragma mark -
#pragma mark CoreDataModelDelegate
-(void) onCoreDataModelChanged
{
    [tableView reloadData];
    [self.calendarView setNeedsDisplay];
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
    LOG_D(@"onFilterChanged:0x%x", filters);

    [[UserSetting getInstance] saveEventfilters:filters];
    
    tableView.eventTypeFilters = filters;

    NSDate * date = [tableView getFirstVisibleDay];
    if (date == nil) {
        date = [NSDate date];
    }

    [tableView reloadFeedEventEntitys:date];
    [self.calendarView setNeedsDisplay];
}


#pragma mark -
#pragma mark FeedEventTableViewDelegate
-(void) onDisplayFirstDayChanged:(NSDate *) firstDay
{
    NSLog(@"onDisplayFirstDayChanged:%@", firstDay);
    [self.calendarView.kalView swith2Date:firstDay];
}

-(void) onEventModelChanged:(BOOL) isSynchronizingData
{
    if(isSynchronizingData) {
        [dataLoadingView startAnim];
    } else {
        [dataLoadingView stopAnim];
    }
}
@end
