
#import "AddEventDateViewController.h"
#import "AddDateCalenderView.h"

#import "TimePicker.h"
#import "DuringTimePicker.h"
#import "KalLogic.h"

@interface AddEventDateViewController ()<AddDateCalenderViewDelegate,KalViewDelegate>
{
    KalLogic *logic;
}

@end

@implementation AddEventDateViewController

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
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)chooseTimeAction
{
    TimePicker *picker = [[TimePicker alloc] init];
    [self.view addSubview:picker];
}

- (void)chooseDurationAction
{
    DuringTimePicker *picker = [[DuringTimePicker alloc] init];
    [self.view addSubview:picker];
}

- (void)didSelectDate:(KalDate *)date
{
    
}
@end
