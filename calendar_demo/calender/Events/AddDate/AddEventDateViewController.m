
#import "AddEventDateViewController.h"
#import "AddDateCalenderView.h"

#import "TimePicker.h"
#import "DuringTimePicker.h"
#import "KalLogic.h"
#import "NavgationBar.h"
#import "KalDate.h"

@interface AddEventDateViewController ()<AddDateCalenderViewDelegate,KalViewDelegate, TimePickerDelegate,DuringTimePickerDelegate,NavgationBarDelegate>
{
    KalLogic *logic;
    EventDate *eventDate;
    
    AddDateCalenderView *calView;
}

@property(nonatomic,copy) EventDate *eventDate;
@end

@implementation AddEventDateViewController
@synthesize delegate;
@synthesize eventDate;

- (id)initWithEventDate:(EventDate *)arrangedDate
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
    
    NavgationBar *navBar = [[NavgationBar alloc] init];
    [self.view addSubview:navBar];
    [navBar setTitle:@"Add Date"];
    [navBar setLeftBtnText:@"Cancel"];
    [navBar setRightBtnText:@"Add"];
    navBar.delegate = self;
    
    [self refreshTimeString];
}

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
    [parts setHour:hours + ampm * 12];
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
//    [parts setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [parts setYear:date.year];
    [parts setMonth:date.month];
    [parts setDay:date.day];
    NSDate *startDate = [gregorian dateFromComponents:parts];
    eventDate.start = startDate;
}

- (void)refreshTimeString
{
    [calView setStartTimeString:[eventDate parseStartTimeString]];
    [calView setDuringTimeString:[eventDate parseDuringDateString]];
}
@end
