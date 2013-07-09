
#import "AddEventDateViewController.h"
#import "AddDateCalenderView.h"

#import "TimePicker.h"
#import "DuringTimePicker.h"
#import "KalLogic.h"

@interface AddEventDateViewController ()<AddDateCalenderViewDelegate,KalViewDelegate, TimePickerDelegate,DuringTimePickerDelegate>
{
    KalLogic *logic;
    EventDate *eventDate;
}

@end

@implementation AddEventDateViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    eventDate = [[EventDate alloc] init];

    NSDate *date = [NSDate date];
    logic = [[KalLogic alloc] initForDate:date];
    
    AddDateCalenderView *calView = [[AddDateCalenderView alloc] initWithdelegate:self logic:logic selectedDate:[KalDate dateFromNSDate:date]];

    [self.view addSubview:calView];
    calView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)AddDate:(id)sender {
    if ([self.delegate respondsToSelector:@selector(setEventDate:)]) {
        [self.delegate setEventDate:eventDate];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)chooseTimeAction
{
    TimePicker *picker = [[TimePicker alloc] init];
    picker.delegate = self;
    [self.view addSubview:picker];
}

- (void)chooseDurationAction
{
    DuringTimePicker *picker = [[DuringTimePicker alloc] init];
    picker.delegate = self;
    [self.view addSubview:picker];
}

#pragma mark delegate
- (void)setStartTimeType:(NSString *)startDateType
{
    eventDate.start_type = startDateType;
}
- (void)setStartTimeHours:(NSInteger)hours Minutes:(NSInteger)minutes AMPM:(NSInteger)ampm
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];    
    NSDateComponents *parts = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:eventDate.start];
    [parts setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [parts setHour:hours + ampm * 12];
    [parts setMinute:minutes];
    NSDate *startDate = [gregorian dateFromComponents:parts];
    eventDate.start = startDate;
}

- (void)setDurationAllDay:(BOOL)allDay
{
    eventDate.is_all_day = allDay;
}

- (void)setDurationHours:(NSInteger)hours Minutes:(NSInteger)minutes
{
    eventDate.duration_hours = hours;
    eventDate.duration_minutes = minutes;
}

-(void) didSelectDate: (KalDate*) date
{
    
}
@end
