
#import "FeedViewController.h"


#import "Navigation.h"

#import "EventView.h"

#import "Location.h"

#import "KalView.h"
#import "KalLogic.h"
#import "KalDate.h"
#import "NSDateAdditions.h"

#import "UserModel.h"
#import "Model.h"
#import "Utils.h"

#import "RootNavContrller.h"
#import "AddEventViewController.h"

#import "EventModel.h"



/*
 FeedViewController show the event list and a calender wiget
 */
@interface FeedViewController () <UITableViewDataSource, UITableViewDelegate,KalViewDelegate>
{
    KalLogic *logic;
    KalView *calendarView;
    
    Navigation* navigation;
    
    UITableView * tableView;
    
    //NSMutableArray * sections;
    //NSMutableDictionary * sectionDict;

    //Month
    //NSMutableDictionary * monthEvents;

    UIActivityIndicatorView * loadingView;
    
    EventModel * eventModel;
    
    int selectedYear;
    int selectedMonth;
    int selectedDay;
}

@property (nonatomic, retain) KalView *calendarView;
@end

@implementation FeedViewController

@synthesize calendarView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    eventModel = [[Model getInstance] getEventModel];
    
    //sections = [[NSMutableArray alloc] init];
    //sectionDict = [[NSMutableDictionary alloc] init];

    navigation = [Navigation createNavigationView];
    navigation.unreadCount.hidden = NO;

    [self.view addSubview:navigation];
    [navigation.leftBtn addTarget:self action:@selector(btnMenu:) forControlEvents:UIControlEventTouchUpInside];
    [navigation.rightBtn addTarget:self action:@selector(btnAddEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    int y = navigation.frame.size.height;

    CGRect frame = self.view.bounds;
    frame.origin.y = y;
    frame.size.height -=(y + 64);
    
    
    tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    
    [tableView setAllowsSelection:NO];
    
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [self.view addSubview:tableView];
    

    
    NSDate *date = [NSDate date];
    logic = [[KalLogic alloc] initForDate:date];
    KalView *kalView = [[KalView alloc] initWithFrame:[self.view bounds] delegate:self logic:logic selectedDate:[KalDate dateFromNSDate:date]];
    [kalView setUserInteractionEnabled:YES];
    [kalView setMultipleTouchEnabled:YES];
    [self.view addSubview:kalView];
    self.calendarView = kalView;
    

    loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadingView.center = self.view.center;
    loadingView.hidesWhenStopped = YES;

    [self.view addSubview:loadingView];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];
    selectedYear = [components year];  //当前的年份
    selectedMonth = [components month];  //当前的月份
    selectedDay = [components day];
    
    [self loadData:selectedYear andMonth:selectedMonth];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}


-(void) loadData:(int) year andMonth:(int)month
{
    [loadingView startAnimating];
    
    
    [[Model getInstance] getEvents:year andMonth:month andCallback:^(NSInteger error, NSArray *events) {
        
        NSLog(@"getEvents:error=%d, events size=%d", error, events.count);
        
        [loadingView stopAnimating];
        
        if(error == 0) {
    
            NSString * strMonth = [Utils formate:year andMonth:month];
            [eventModel setEvents:events forMonth:strMonth];
             
            [tableView reloadData];
            
            [self tableviewScroll2SelectDay];
            
        } else {
            //TODO:: show network error
        }
    }];
}


#pragma mark -
#pragma mark btnEvent

- (void)btnMenu:(id)sender
{
    navigation.unreadCount.hidden = YES;

    if(self.delegate != nil) {
        [self.delegate onBtnMenuClick];
    }
}

- (void)btnAddEvent:(id)sender
{
    AddEventViewController *addEvent = [[AddEventViewController alloc] initWithNibName:@"AddEventViewController" bundle:nil];
    [[RootNavContrller defaultInstance] pushViewController:addEvent animated:YES];
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
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(58, 0, 1, 24)];
    float colorVal = 227.0/255.0;
    line.backgroundColor = [UIColor colorWithRed:colorVal green:colorVal blue:colorVal alpha:1];
    [view addSubview:line];
    
    UIImageView * dotView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"dot"]];
    dotView.frame = CGRectMake(54, 7, 10, 10);
    [view addSubview:dotView];
    
    float fontColor = 172.0/255.0;
    
    UILabel * dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(68, 5, 320-68, 16)];
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark kalViewDelegate

- (void)didSelectDate:(KalDate *)date
{
    NSLog(@"didSelectDate:%@", date);

    if(!loadingView.isHidden) {
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
        
        [self loadData:selectedYear andMonth:selectedMonth];
        
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

- (void)monthModeToEventMode
{
    CGRect frame = navigation.frame;
    frame.origin.y = -44;
    
    CGRect frame2 = tableView.frame;
    frame2.origin = CGPointMake(0, 0);
    
    [UIView animateWithDuration:0.5 animations:^{
        [navigation setFrame:frame];
        [tableView setFrame:frame2];
    }completion:^(BOOL finish)
     {
         
     }];
}

- (void)eventModeToMontMode
{
    CGRect frame = navigation.frame;
    frame.origin.y = 0;
    
    CGRect frame2 = tableView.frame;
    frame2.origin = CGPointMake(0, 44);
    
    [UIView animateWithDuration:0.5 animations:^{
        [navigation setFrame:frame];
        [tableView setFrame:frame2];
    }completion:^(BOOL finish)
     {
         
     }];
}
@end
