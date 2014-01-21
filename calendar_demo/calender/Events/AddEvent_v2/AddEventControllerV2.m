#import "AddEventControllerV2.h"
#import "ExtendTextField.h"
#import "AddEventAddTitleBar.h"
#import "ExtendTextField.h"
#import "DeviceInfo.h"
#import "AETimeEntry.h"
#import "AEOptionentry.h"
#import "AEInviteesEntry.h"
#import "AELocalEntry.h"
#import "UIView+FrameResize.h"

#import "CEventTimePicker.h"

#import "AddLocationViewController.h"
#import "AddEventInviteViewController.h"

#import "ATMHud.h"
#import "ATMHudDelegate.h"

#import "Model.h"
#import "CoreDataModel.h"

#import "AddEventInviteePlaceView.h"

#import "UploadUIImageView.h"

#import "Utils.h"
#import "RootNavContrller.h"

@interface AddEventControllerV2 ()<AddEventAddTitleBarDelegate,
                                    UIScrollViewDelegate,
                                    AddEventInviteViewControllerDelegate,
                                    AddLocationViewControllerDelegate,
                                    EventDetailInviteePlaceViewDelegate,
                                    AEEntryViewProtocal,
                                    CEventTimePickerDelegate,
                                    ATMHudDelegate,
                                    UITextFieldDelegate>
{
    AddEventAddTitleBar *navBar;
    
    UploadUIImageView * uploadImageView;
    
    
    ExtendTextField *txtFieldTitle;
    UIScrollView *scrollView;
    
    AEOptionentry *opentionEntry;
    AEInviteesEntry *inviteesEntry;
    AELocalEntry *localEntry;
    AETimeEntry *timeEntry;
    
    BOOL haveOptionViewShow;
    
    ATMHud *hud;
    ASIFormDataRequest * request;
    
    AddEventInviteePlaceView *invitePlaceContentView;
}

@property(nonatomic, strong) NSArray *invitedPeoples;
@property(nonatomic, strong) Location *locationPlace;
@property(nonatomic, strong) NSMutableArray *timePickerArray;

@end

@implementation AddEventControllerV2
@synthesize invitedPeoples;
@synthesize locationPlace;
@synthesize timePickerArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    txtFieldTitle.delegate = nil;
    navBar.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:222/255.0f green:235/255.0f blue:238/255.0f alpha:1.0f]];
    
    UIImageView * bg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bg.image = [UIImage imageNamed:@"invitee_people_bg"];
    [self.view addSubview:bg];
    
    haveOptionViewShow = false;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchedInView:)];
    [self.view addGestureRecognizer:gesture];
    
    
    self.timePickerArray = [[NSMutableArray alloc] init];
    
    //scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, [DeviceInfo fullScreenHeight])];
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.autoresizesSubviews = NO;
    [self.view addSubview:scrollView];
    scrollView.delegate = self;
    [scrollView setBounces:NO];
    
    [self initImagePickerView];
    [self initOptionView];
    
    [self createInvitePlaceView];
    
    [self initHub];
    
    navBar = [[AddEventAddTitleBar alloc] init];
    [self.view addSubview:navBar];
    navBar.delegate = self;
    [navBar setTitleHidden:YES];
}

- (void)touchedInView:(UITapGestureRecognizer*) tap
{
    [txtFieldTitle resignFirstResponder];
    for (CEventTimePicker *timePicker in self.timePickerArray) {
        [timePicker loseFocus];
    }
    
    [self layoutSubViews];
}


- (void)initHub
{
    hud = [[ATMHud alloc] initWithDelegate:self];
	[self.view addSubview:hud.view];
}

- (void)createInvitePlaceView
{
    invitePlaceContentView = [[AddEventInviteePlaceView alloc] initByCreator:YES CanChangeLocation:YES];
    invitePlaceContentView.delegate = self;
    [scrollView addSubview:invitePlaceContentView];
    [invitePlaceContentView setHidden:YES];
}

-(UIImage *) getRandomPhoto
{
    //event_detail_random_header1.png
    int value = (arc4random() % 8) + 1;
    
    NSString * name = [NSString stringWithFormat:@"event_detail_random_header%d.png", value];
    UIImage * img = [UIImage imageNamed:name];
    return img;
}

- (void)initImagePickerView
{
    uploadImageView = [[UploadUIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 207)];
    //uploadImageView.imagePickerView.image = [UIImage imageNamed:@"imagePicker_bg.jpg"];
    uploadImageView.imagePickerView.image = [self getRandomPhoto];
    uploadImageView.controller = self;
    [scrollView addSubview:uploadImageView];
    
    
    UIImageView *imageTitleBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imagePickerTitleBg.png"]];
    [imageTitleBgView setFrame:CGRectMake(6, 142, 308, 46)];
    [uploadImageView addSubview:imageTitleBgView];
    
    txtFieldTitle = [[ExtendTextField alloc] initWithFrame:CGRectMake(imageTitleBgView.frame.origin.x, imageTitleBgView.frame.origin.y + 10, imageTitleBgView.frame.size.width, 30)];
    [txtFieldTitle setPlaceholder:@"Add a title..."];
    [txtFieldTitle setUserInteractionEnabled:NO];
    [txtFieldTitle setFont:[UIFont systemFontOfSize:18]];
    [txtFieldTitle setTextColor:[UIColor whiteColor]];
    [txtFieldTitle setTextAlignment:NSTextAlignmentCenter];
    [txtFieldTitle setEnabled:YES];
    [txtFieldTitle setUserInteractionEnabled:YES];
    txtFieldTitle.delegate = self;
    [txtFieldTitle addTarget:self action:@selector(txtDidEnd) forControlEvents:UIControlEventEditingDidEndOnExit];
    txtFieldTitle.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    [uploadImageView addSubview:txtFieldTitle];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*0.3), dispatch_get_main_queue(),  ^(void) {
        [txtFieldTitle becomeFirstResponder];
    });
    
}

- (void)initOptionView
{
    opentionEntry = [AEOptionentry createView];
    inviteesEntry = [AEInviteesEntry createView];
    localEntry = [AELocalEntry createView];
    timeEntry = [AETimeEntry createView];
    [scrollView addSubview:opentionEntry];
    [scrollView addSubview:inviteesEntry];
    [scrollView addSubview:localEntry];
    [scrollView addSubview:timeEntry];
    
    [opentionEntry setOrginY:[uploadImageView getMaxY] + 17];
    [inviteesEntry setOrginY:[uploadImageView getMaxY] + 17];
    [localEntry setOrginY:[inviteesEntry getMaxY] + 17];
    [timeEntry setOrginY:[localEntry getMaxY] + 17];
    
    [opentionEntry setHidden:YES];
    [inviteesEntry setHidden:YES];
    [localEntry setHidden:YES];
    [timeEntry setHidden:YES];
    
    opentionEntry.delegate = self;
    inviteesEntry.delegate = self;
    localEntry.delegate = self;
    timeEntry.delegate = self;
}

- (void)addDate
{
//    NSArray * times = [timesView getEventDates];
//    
//    ProposeStart * tempEventDate = [[ProposeStart alloc] init];
//    
//    if(times.count == 0) {
//        tempEventDate.duration_hours = 1;
//        tempEventDate.start = [NSDate dateWithTimeIntervalSinceNow:300];
//        tempEventDate.start_type = START_TYPEEXACTLYAT;
//        [tempEventDate convertMinToQuarterMode];
//        
//    } else {
//        
//        ProposeStart * time  = [times lastObject];
//        tempEventDate.duration_minutes = time.duration_minutes;
//        tempEventDate.duration_hours = time.duration_hours;
//        tempEventDate.duration_days = time.duration_days;
//        tempEventDate.is_all_day = time.is_all_day;
//        tempEventDate.start = time.start;
//        tempEventDate.start_type = time.start_type;
//    }
}

- (void)txtDidEnd
{
    [txtFieldTitle resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([toBeString length] > 200) {
        return NO;
    }
    
    [self doShowOptionViewAnimation];
    
    return YES;
}

- (void)didTapdView:(UIView *)view
{
    [txtFieldTitle resignFirstResponder];
    
    if (view == opentionEntry)
    {
        [self doShowOptionViews];
    }
    else if (view == inviteesEntry)
    {
        [self addInvitePeople];
    }
    else if (view == localEntry)
    {
        [self addLocation];
    }
    else if (view == timeEntry)
    {
        [self addNewDate];
    }
}

- (void)addNewDate
{

    
    CEventTimePicker *timePicker = [[CEventTimePicker alloc] init];
    
    ProposeStart *start = [[ProposeStart alloc] init];
    start.start = [NSDate date];
    start.start_type = START_TYPEWITHIN;
    start.duration_hours = 1;
    start.duration_minutes = 0;
    
    if([self.timePickerArray count] == 0)
    {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *parts = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:start.start];
        
        NSInteger minutes = parts.minute;
        NSInteger remainder = minutes % 5;
        if (remainder != 0) {
            NSDateComponents *c = [[NSDateComponents alloc] init];
            c.minute = 5 - remainder;
            start.start = [[NSCalendar currentCalendar] dateByAddingComponents:c toDate:start.start options:0];
        }
    }
    else if ([self.timePickerArray count] > 0)
    {
        CEventTimePicker *picker = [self.timePickerArray objectAtIndex:[self.timePickerArray count] - 1];
        ProposeStart *time = [picker getTime];
        start.start_type = time.start_type;
        start.duration_hours = time.duration_hours;
        start.duration_minutes = time.duration_minutes;
        
        NSDateComponents *c = [[NSDateComponents alloc] init];
        c.hour = 1;
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        start.start = [gregorian dateByAddingComponents:c toDate:time.start options:0];
    }
    
    [timePicker setTime:start];
    [self.timePickerArray addObject:timePicker];
    [timePicker setOrginY:timeEntry.frame.origin.y];
    [scrollView addSubview:timePicker];
    timePicker.delegate = self;
    [timePicker getFocus];
    
    if ([self.timePickerArray count] >= 1) {
        [timeEntry setTitleText:[NSString stringWithFormat: @"Add %drd Date or Time Option", [self.timePickerArray count] + 1]];
    }
    timeEntry.hidden = [self.timePickerArray count] >= 3;
    
    [self layoutSubViews];
}

- (NSArray *)getTimesArray
{
    NSMutableArray *timeArray = [[NSMutableArray alloc] initWithCapacity:3];
    for (CEventTimePicker *picker in self.timePickerArray) {
        [timeArray addObject:[picker getTime]];
    }
    
    return timeArray;
}

- (void)layoutSubViews
{
    NSInteger maxY = 0;
    NSInteger gap = 17;
    
    maxY = [uploadImageView getMaxY];
    
    if (opentionEntry)
    {
        [opentionEntry setOrginY:maxY + gap];
        return;
    }
    
    if (self.invitedPeoples != nil && self.locationPlace != nil)
    {
        [invitePlaceContentView setOrginY:maxY];
        [invitePlaceContentView setHidden:NO];
        [inviteesEntry setHidden:YES];
        [localEntry setHidden:YES];
        [invitePlaceContentView setLocation:self.locationPlace];
        [invitePlaceContentView updateInvitee:self.invitedPeoples];
        [invitePlaceContentView setInviteesAndLocationMode];
        maxY = [invitePlaceContentView getMaxY];
    }
    else
    {
        if (self.invitedPeoples != nil)
        {
            [invitePlaceContentView setOrginY:maxY];
            [invitePlaceContentView setHidden:NO];
            [inviteesEntry setHidden:YES];
            [invitePlaceContentView updateInvitee:self.invitedPeoples];
            [invitePlaceContentView setInviteesMode];
            maxY = [invitePlaceContentView getMaxY];
        }
        else if (self.locationPlace != nil)
        {
            [invitePlaceContentView setOrginY:maxY];
            [invitePlaceContentView setHidden:NO];
            [localEntry setHidden:YES];
            [invitePlaceContentView setLocation:self.locationPlace];
            [invitePlaceContentView setLocationMode];
            maxY = [invitePlaceContentView getMaxY];
        }

        if (self.invitedPeoples == nil)
        {
            [inviteesEntry setOrginY:maxY + gap];
            maxY = [inviteesEntry getMaxY];
        }
        
        if (self.locationPlace == nil)
        {
            [localEntry setOrginY:maxY + gap];
            maxY = [localEntry getMaxY];
        }
    }
    
    maxY += 16.0f;
    if ([self.timePickerArray count] > 0) {
        for (CEventTimePicker *picker in self.timePickerArray) {
            [picker setOrginY:maxY + 1.0f];
            maxY = [picker getMaxY];
        }
    }

    int timeCount = self.timePickerArray.count;
    if (timeCount >= 1) {
        [timeEntry setTitleText:[NSString stringWithFormat: @"Add %drd Date or Time Option", timeCount + 1]];
    } else {
        [timeEntry setTitleText:@"Add Date or Time Option"];
    }
    
    timeEntry.hidden = (timeCount >= 3);
    
    
    if (timeEntry.hidden != YES)
    {
        [timeEntry setOrginY:maxY + 1.0f];
        maxY = [timeEntry getMaxY];
    }

    
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, maxY + gap)];
}

- (void)doShowOptionViewAnimation
{
    if (!haveOptionViewShow) {
        haveOptionViewShow = YES;
    }
    else
    {
        return;
    }
    [opentionEntry setHidden:NO];
    [opentionEntry setAlpha:0.0f];
    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [opentionEntry setAlpha:1.0f];
    } completion:^(BOOL finished) {
        ;
    }];
}

- (void)doShowOptionViews
{
    [opentionEntry setHidden:NO];
    [inviteesEntry setHidden:NO];
    [localEntry setHidden:NO];
    [timeEntry setHidden:NO];
    
    [inviteesEntry setTransform:CGAffineTransformMakeTranslation(320, 0)];
    [localEntry setTransform:CGAffineTransformMakeTranslation(320, 0)];
    [timeEntry setTransform:CGAffineTransformMakeTranslation(320, 0)];
    [UIView animateWithDuration:.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [opentionEntry setTransform:CGAffineTransformMakeTranslation(-320, 0)];
        [inviteesEntry setTransform:CGAffineTransformMakeTranslation(0, 0)];
        [localEntry setTransform:CGAffineTransformMakeTranslation(0, 0)];
        [timeEntry setTransform:CGAffineTransformMakeTranslation(0, 0)];
    } completion:^(BOOL finished) {
        [opentionEntry removeFromSuperview];
        opentionEntry = nil;
    }];
}

#pragma mark AddLocation
- (void)addLocation
{
    AddLocationViewController *addLocation = [[AddLocationViewController alloc] initWithNibName:@"AddLocationViewController" bundle:nil];
    addLocation.delegate = self;
    addLocation.location = self.locationPlace;
    
    [self.navigationController pushViewController:addLocation animated:YES];
}

- (void)setLocation:(Location *)location_
{
    self.locationPlace = location_;
    [self layoutSubViews];
}

#pragma mark Add People
- (void)addInvitePeople
{
    AddEventInviteViewController *invitePeople = [[AddEventInviteViewController alloc] initWithNibName:@"AddEventInviteViewController" bundle:nil];
    invitePeople.delegate = self;
    
    [invitePeople setType:AddInviteeTypeAll];
    [invitePeople setSelectedUser:invitedPeoples];
    
    [self.navigationController pushViewController:invitePeople animated:YES];
}

- (void)setInVitePeopleArray:(NSArray *)inviteArray
{
    self.invitedPeoples = inviteArray;
    [self layoutSubViews];
}

#pragma mark EventDetailInviteePlaceViewDelegate
- (void) onInviteeViewClicked
{
    [self addInvitePeople];
}

- (void)changeLocation
{
    [self addLocation];
}

- (BOOL)canCreateEvent
{
    NSString *title = txtFieldTitle.text;
    
    if (title == nil) {
        return NO;
    }
    
    title = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(title.length == 0) {
        return NO;
    }
    
    return YES;
}

- (void)showEventContentWarning
{
    NSString *alertString = @"need a title !!";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:alertString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark NavBarDelegate
- (void)leftNavBtnClick
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType: kCATransitionMoveIn];
    [animation setSubtype: kCATransitionFromBottom];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
    [[RootNavContrller defaultInstance] popViewControllerAnimated:NO];
    [[RootNavContrller defaultInstance].view.layer addAnimation:animation forKey:nil];
}

- (void)rightNavBtnClick
{
    if (![self canCreateEvent]) {
        [self showEventContentWarning];
        return;
    }
    
    [self createEvent];
}


- (void)createEvent
{
    NSString * imgUrl = uploadImageView.uploadImageUrl;
    
    NSString *title = txtFieldTitle.text;
    title = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    Event *event = [[Event alloc] init];
    event.eventType = 0;
    event.description = @"";
    
    NSMutableArray * invitees = [[NSMutableArray alloc] init];
    for(Contact * user in self.invitedPeoples) {
        Invitee * invitee = [[Invitee alloc] init];
        invitee.email = user.email;
        [invitees addObject:invitee];
    }
    
    event.invitees = invitees;
    
    
    //    event.duration_days = arrangedDate.duration_days;
    //    event.duration_hours = arrangedDate.duration_hours;
    //    event.duration_minutes = arrangedDate.duration_minutes;
    //    event.is_all_day = arrangedDate.is_all_day;
    //    event.start = arrangedDate.start;
    //    event.start_type = arrangedDate.start_type;
    
    
    event.timezone = [NSTimeZone systemTimeZone].name;
    event.propose_starts = [self getTimesArray];
    event.location = self.locationPlace;
    
    if(imgUrl == nil) {
        event.thumbnail_url = @"";
    } else {
        event.thumbnail_url = imgUrl;
    }
    
    
    event.title = title;
    event.allow_new_dt = YES;
    event.allow_attendee_invite = YES;
    event.allow_new_location = YES;
    event.created_on = [NSDate date];
    event.published = YES;
    
    Model *model = [Model getInstance];
    
    [self startIndicator];
    
    [navBar setRightBtnEnable:NO];
    
    [model createEvent:event andCallback:^(NSInteger error, Event * newEvent) {
        
        [self stopIndicator];
        
        [navBar setRightBtnEnable:YES];
        
        if (error == 0) {
            
            CoreDataModel * model = [CoreDataModel getInstance];
            FeedEventEntity * entity = [model createEntity:@"FeedEventEntity"];
            [entity convertFromEvent:newEvent];
            [model addFeedEventEntity:entity];
            [model saveData];
            [model notifyModelChange];
            
            [self leftNavBtnClick];
            
        } else {
            
            [Utils showUIAlertView:@"Error" andMessage:@"Create event failed"];
        }
    }];
}

- (void)startIndicator
{
    [hud setCaption:@"Creating Event"];
    [hud setActivity:YES];
    [hud show];
    [hud setBlockTouches:YES];
}

- (void)stopIndicator
{
    [hud setProgress:0.0f];
    [hud setActivity:NO];
    [hud setBlockTouches:NO];
    [hud hide];
    [self.view setUserInteractionEnabled:YES];
}


- (void)EventTimePickerNeedLayout:(CEventTimePicker*)picker
{
    [self layoutSubViews];
}

- (void)eventTimePickerDelete:(CEventTimePicker*)picker
{
    for (CEventTimePicker * timepicker in self.timePickerArray) {
        
        if(picker == timepicker) {
            [self.timePickerArray removeObject:picker];
            [picker removeFromSuperview];
            [self layoutSubViews];
            return;
        }
     }
}

@end
