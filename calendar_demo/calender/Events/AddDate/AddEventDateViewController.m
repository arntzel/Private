
#import "AddEventDateViewController.h"
#import "AddDateCalenderView.h"

#import "TimePicker.h"
#import "DuringTimePicker.h"
#import "KalLogic.h"
#import "NavgationBar.h"
#import "KalDate.h"

#import "EventView.h"
#import "BirthdayEventView.h"


#import "Utils.h"
#import "CoreDataModel.h"
#import "ViewUtils.h"

@interface AddEventDateViewController ()<AddDateCalenderViewDelegate,
                                         KalViewDelegate,
                                         KalTileViewDataSource,
                                         TimePickerDelegate,
                                         DuringTimePickerDelegate,
                                         NavgationBarDelegate,
                                         UITableViewDataSource,
                                         UITableViewDelegate>
{
    KalLogic *logic;
    ProposeStart * eventDate;
    
    AddDateCalenderView *calView;

    UITableView * feedTableView;
 
    NSArray * dayEvents;
}

@property(nonatomic,copy) ProposeStart *eventDate;
@end

@implementation AddEventDateViewController
@synthesize delegate;
@synthesize eventDate;

- (id)initWithEventDate:(ProposeStart *)arrangedDate
{
    if (self = [super init]) {
        self.eventDate = arrangedDate;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    logic = [[KalLogic alloc] initForDate:eventDate.start];
    
    calView = [[AddDateCalenderView alloc] initWithdelegate:self logic:logic selectedDate:[KalDate dateFromNSDate:eventDate.start]];

    [self.view addSubview:calView];
    calView.delegate = self;
    [[calView getKalView] setKalTileViewDataSource:self];


    NavgationBar *navBar = [[NavgationBar alloc] init];
    [self.view addSubview:navBar];
    [navBar setTitle:@"Add Date"];
    [navBar setLeftBtnText:@"Cancel"];
    [navBar setRightBtnText:@"Add"];
    navBar.delegate = self;


    int top = navBar.frame.size.height;
    int bottom = calView.frame.origin.y;

    feedTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, top, 320, bottom-top) style:UITableViewStylePlain];
    feedTableView.allowsSelection = NO;
    feedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    feedTableView.backgroundColor = [UIColor whiteColor];
    feedTableView.dataSource = self;
    feedTableView.delegate = self;

    [self.view addSubview:feedTableView];

    [self refreshTimeString];
    
    [self loadEvents:[NSDate date]];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(dayEvents == nil || dayEvents.count == 0) {
        return 1;
    }

    return dayEvents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(dayEvents == nil || dayEvents.count == 0) {
        UITableViewCell * cell = (UITableViewCell*)[ViewUtils createView:@"NoEventView"];
        return cell;
    }
    
    FeedEventEntity * event = [dayEvents objectAtIndex:indexPath.row];

    if( ![event isBirthdayEvent] ) {
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(dayEvents == nil || dayEvents.count == 0) {
        return 55;
    }

    FeedEventEntity * event = [dayEvents objectAtIndex:indexPath.row];

    if( [event isBirthdayEvent] ) {
        return BirthdayEventView_Height;
    } else {
        return PlanView_HEIGHT;
    }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftNavBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightNavBtnClick
{
    if ([self timeIsInFuture])
    {
        if ([self.delegate respondsToSelector:@selector(setEventDate:)])
        {
            [self.delegate setEventDate:eventDate];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self showTimeErrorWarning];
    }
}

- (void)showTimeErrorWarning
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                    message:@"Do not choose the past time please!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}

- (BOOL)timeIsInFuture
{
    if ([eventDate.start timeIntervalSince1970] > [[NSDate date] timeIntervalSince1970]) {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)chooseTimeAction
{
    TimePicker *picker = [[TimePicker alloc] init];
    picker.delegate = self;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *parts = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:eventDate.start];
    [parts setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [picker setHours:parts.hour Minutes:parts.minute Animation:NO];
    [picker setStartTimeType:eventDate.start_type];

    [self.view addSubview:picker];
}

- (void)chooseDurationAction
{
    DuringTimePicker *picker = [[DuringTimePicker alloc] init];
    picker.delegate = self;
    [picker setHours:eventDate.duration_hours Minutes:eventDate.duration_minutes Animation:NO];
    [picker setisAllDate:eventDate.is_all_day];
    [picker setAllDays:eventDate.duration_days Animation:NO];
    [self.view addSubview:picker];
}

#pragma mark delegate
- (void)setStartTimeType:(NSString *)startDateType
{
    eventDate.start_type = startDateType;
    
    [self refreshTimeString];
}

- (void)setStartTimeHours:(NSInteger)hours Minutes:(NSInteger)minutes AMPM:(NSInteger)ampm
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];    
    NSDateComponents *parts = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:eventDate.start];
//    [parts setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    if(ampm == 0 && hours == 12) {
        
       [parts setHour:0];
        
    } else if (ampm == 1 && hours == 12) {
        
        [parts setHour:12];
        
    } else {
        [parts setHour:hours + ampm*12];
    }
    

    [parts setMinute:minutes];
    NSDate *startDate = [gregorian dateFromComponents:parts];
    eventDate.start = startDate;
    
    [self refreshTimeString];
}

- (void)setDurationAllDay:(BOOL)allDay
{
    eventDate.is_all_day = allDay;
    
    [self refreshTimeString];
}

- (void)setDurationDays:(NSInteger)days
{
    eventDate.duration_days = days;
    [self refreshTimeString];
}

- (void)setDurationHours:(NSInteger)hours Minutes:(NSInteger)minutes
{
    eventDate.duration_hours = hours;
    eventDate.duration_minutes = minutes;
    
    [self refreshTimeString];
}

-(void) didSelectDate: (KalDate*) date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *parts = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:eventDate.start];
    [parts setYear:[date year]];
    [parts setMonth:[date month]];
    [parts setDay:[date day]];
    
    NSDate *startDate = [gregorian dateFromComponents:parts];
    eventDate.start = startDate;
    [self loadEvents:eventDate.start];
}

-(void) loadEvents: (NSDate*) date
{
    NSString * day = [Utils formateDay:date];
    
    CoreDataModel * model = [CoreDataModel getInstance];
    int filetVal = FILTER_BIRTHDAY | FILTER_FB | FILTER_IMCOMPLETE | FILTER_GOOGLE | FILTER_IOS;
    dayEvents =[model getFeedEvents:day evenTypeFilter:filetVal];
    [feedTableView reloadData];
}

- (void)refreshTimeString
{
    [calView setStartTimeString:[eventDate parseStartTimeString]];
    [calView setDuringTimeString:[eventDate parseDuringDateString]];
}

#pragma mark -
#pragma mark KalTileViewDataSource
-(int) getEventType:(KalDate *) date {

    NSString * day = [Utils formateDay:[date NSDate]];
    int type =[[CoreDataModel getInstance] getDayFeedEventType:day];
    return type;
}

@end
