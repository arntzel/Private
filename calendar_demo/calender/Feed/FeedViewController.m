
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

#import "LoginMainViewController.h"

#import "UserSetting.h"
#import "BLRView.h"
#import "iCalEventShowSettingsViewController.h"
/*
 FeedViewController show the event list and a calender wiget
 */
@interface FeedViewController () <KalViewDelegate,
                                  KalTileViewDataSource,
                                  EventFilterViewDelegate,
                                  FeedEventTableViewDelegate,
                                  CoreDataModelDelegate,
                                  EventModelDelegate,
                                  FeedViewControllerDelegate,
                                  UIAlertViewDelegate>
{
    KalLogic *logic;
    FeedCalenderView *calendarView;
    FeedEventTableView * tableView;
    BLRView *blrView;
    
    BOOL isBlured;
   
    CustomerIndicatorView * dataLoadingView;
    
    //bool fristLoadData;
    //For update new app version
    NSString * newAppVersionUrl;
}

@property (nonatomic, retain) FeedCalenderView *calendarView;

@end

@implementation FeedViewController

@synthesize calendarView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    LOG_D(@"FeedViewController viewDidLoad");

    User * me = [[UserModel getInstance] getLoginUser];
    if(me.timezone != nil) {
        [Utils  setUserTimeZone:[NSTimeZone timeZoneWithName:me.timezone]];
    } else {
        [Utils setUserTimeZone:[NSTimeZone systemTimeZone]];
    }
    
    
    [self checkAppUpdated];
    
    //[self.navigation.calPendingSegment setSelectedSegmentIndex:0];
    self.navigation.calPendingSegment.hidden = NO;
    [self.navigation.calPendingSegment addTarget:self.delegate action:@selector(onSegmentPressed:) forControlEvents:UIControlEventValueChanged];
    [self.navigation.rightBtn addTarget:self action:@selector(btnAddEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    int y = self.navigation.frame.size.height;

    CGRect frame = self.view.bounds;
    frame.origin.y = y;
    //frame.size.height -=(y + 64);
    frame.size.height -=y;
    
    tableView = [[FeedEventTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //tableView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    tableView.feedEventdelegate = self;
    
    UIView *bgview = [[UIView alloc] initWithFrame: tableView.frame];
    bgview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"feed_background_image.png"]];
    tableView.backgroundView = bgview;
    
    [self.view addSubview:tableView];
    
    
    //Load BLRView
    blrView = [[BLRView alloc] init];
    CGRect blurFrame = self.view.bounds;
    //blurFrame.size.height = self.view.bounds.size.height / 2;
    blrView.frame = blurFrame;
    blrView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //[blrView  blurWithColor:[BLRColorComponents darkEffect]];
    [blrView setHidden:YES];
    [self.view addSubview:blrView];
    isBlured = NO;
    
    
    NSDate *date = [Utils getCurrentDate];
    logic = [[KalLogic alloc] initForDate:date];
    
    self.calendarView = [[FeedCalenderView alloc] initWithdelegate:self controllerDelegate:self logic:logic selectedDate:[KalDate dateFromNSDate:date]];
    [self.calendarView setUserInteractionEnabled:YES];
    [self.calendarView setMultipleTouchEnabled:YES];
    [self.calendarView setKalTileViewDataSource:self];
    [self.view addSubview:self.calendarView];

    int filters = [[UserSetting getInstance] getEventfilters];
    LOG_D(@"Read filterVal:0x %x", filters);
    
    if(![me isFacebookConnected]) {
        filters &= FILTER_IMCOMPLETE|FILTER_GOOGLE|FILTER_IOS;
    }
    
    if(![me isGoogleConnected]) {
        filters &= FILTER_IMCOMPLETE|FILTER_FB|FILTER_BIRTHDAY|FILTER_IOS;
    }
    
    
    [self.calendarView.filterView setFilter:filters];
    tableView.eventTypeFilters = filters;
    self.calendarView.filterView.filterDelegate = self;

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *iCalTypes = [userDefaults objectForKey:@"iCalTypes"];
    if (!iCalTypes)
    {
        EKEventStore *store = [[EKEventStore alloc] init];
        if ([store respondsToSelector:@selector(requestAccessToEntityType:completion:)])
        {
            [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                if (granted)
                {
                    NSMutableArray *_iCalTypes = [[NSMutableArray alloc] init];
                    NSArray *iCals = [store calendarsForEntityType:EKEntityTypeEvent];
                    for (EKCalendar *tmp in iCals)
                    {
                        [_iCalTypes addObject:tmp.calendarIdentifier];
                        
                    }
                    [userDefaults setObject:_iCalTypes forKey:@"iCalTypes"];
                    [userDefaults synchronize];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.calendarView.filterView updateView];
                    });
                    
                }
                
                
                
            }];
        }
        
    }
    
    dataLoadingView = [[CustomerIndicatorView alloc] init];
    frame = dataLoadingView.frame;
    frame.origin.x = 320 + 40;
    frame.origin.y = 55;
    dataLoadingView.frame = frame;
   
    [self.view addSubview:dataLoadingView];
    
    
    [[CoreDataModel getInstance] addDelegate:self];
    [[[Model getInstance] getEventModel] addDelegate:self];
    
    
    
    
    [[[Model getInstance] getEventModel] checkSettingUpdate];
    
    
    [[CoreDataModel getInstance] addDelegate:self];
    [[[Model getInstance] getEventModel] addDelegate:self];
    [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(uploadCalendarEvents1) userInfo:nil repeats:YES];
    
    
    NSString * last_modify_num = [[UserSetting getInstance] getStringValue:KEY_LASTUPDATETIME];
    //第一次Load数据， 先Load当前事件的部分event 数据，然后在开始同步数据任务
    if(last_modify_num == nil) {
        
        NSDate * today =  [Utils getCurrentDate];
        
        [[[Model getInstance] getEventModel] setSynchronizeData:YES];
        
        NSMutableString * eventType = [[NSMutableString alloc] init];
        [eventType appendString:@"0,5"];
        
        if([me isFacebookConnected]) {
            [eventType appendString:@",3,4"];
        }
        
        if( [me isGoogleConnected]) {
            [eventType appendString:@",1,2"];
        }
        
        
        [[Model getInstance] getEventsOfBegin:today andOffset:0 andEventType:eventType andCallback:^(NSInteger error, NSInteger count, NSArray *events) {
        
            [[[Model getInstance] getEventModel] setSynchronizeData:NO];
            
            if(error == 0) {
                CoreDataModel * model = [CoreDataModel getInstance];
                for(Event * evt in events) {
                    
                    FeedEventEntity * entity =[model getFeedEventEntity:evt.id];
                    
                    if(entity == nil) {
                        entity = [model createEntity:@"FeedEventEntity"];
                    } else {
                        for(UserEntity * user in entity.attendees) {
                            [model deleteEntity:user];
                        }
                        
                        [entity clearAttendee];
                    }
                    
                    [entity convertFromEvent:evt];
                    [model updateFeedEventEntity:entity];
                }
                
                [tableView reloadFeedEventEntitys:[Utils getCurrentDate]];
                [self scroll2Today];
            }
            
            [[[Model getInstance] getEventModel] synchronizedFromServer];
        }];
        
    } else {
        [tableView reloadFeedEventEntitys:[Utils getCurrentDate]];
        [self scroll2Today];
    }
    
}

- (void)dealloc
{
    if (blrView) {
        [blrView unload];
    }
}

-(void)blurBackground
{
    if (blrView) {
        if (!isBlured) {
            [blrView  blurWithColor:[BLRColorComponents darkEffect]];
            isBlured = YES;
        }
        [blrView setHidden:NO];
    }
}

-(void)unloadBlurBackground
{
    if (blrView) {
        //[blrView unload];
        [blrView setHidden:YES];
        isBlured = NO;
    }
}

-(void) scrollToTodayFeeds
{
    //[self scroll2Date:[Utils getCurrentDate] animated:YES];
    NSDate *today = [Utils getCurrentDate];
    [self onDisplayFirstDayChanged:today];
    NSString * day = [Utils formateDay:today];
    [tableView scroll2SelectedDate:day];
}

-(void)viewDidUnload {
    [[CoreDataModel getInstance] removeDelegate:self];
    [[[Model getInstance] getEventModel] removeDelegate:self];
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigation.calPendingSegment setSelectedSegmentIndex:0];
}



-(void) scroll2Today
{
    [self scroll2Date:[Utils getCurrentDate] animated:NO];
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
    if(alertView.tag == 2) {
        
        if(buttonIndex != 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:newAppVersionUrl]];
        }
        return;
    }
    
    
    if(buttonIndex == 0) {
        
        [[UserModel getInstance] setLoginUser:nil];
        [[UserSetting getInstance] reset];
        [[CoreDataModel getInstance] reset];
        
        RootNavContrller *navController = [RootNavContrller defaultInstance];
        [navController popToRootViewControllerAnimated:NO];
        
        LoginMainViewController* rootController = [[LoginMainViewController alloc] init];
        [navController pushViewController:rootController animated:NO];
        
    } else {
        
        [[[Model getInstance] getEventModel] synchronizedFromServer];
    }
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    if(alertView.tag == 2) {
     
        //TODO::
    } else {
        [[self navigationController] popViewControllerAnimated:YES];
    }
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
    NSDate * date = [tableView getFirstVisibleDay];
    if (date == nil) {
        date = [Utils getCurrentDate];
    }
    
    [tableView reloadFeedEventEntitys:date];
    [tableView scroll2Date:[Utils formateDay:date] animated:NO];
    
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
        date = [Utils getCurrentDate];
    }

    [tableView reloadFeedEventEntitys:date];
    [self.calendarView setNeedsDisplay];
    [self.calendarView updateFilterFrame];
    
    NSMutableDictionary * setting = [[NSMutableDictionary alloc] init];
    
    NSMutableString * types = [[NSMutableString alloc] init];
    
    if( (filters & FILTER_IMCOMPLETE) != 0)  [types appendString:@"0,"];
    if( (filters & FILTER_GOOGLE) != 0)      [types appendString:@"1,"];
    if( (filters & FILTER_FB) != 0)          [types appendString:@"3,"];
    if( (filters & FILTER_BIRTHDAY) != 0)    [types appendString:@"4,"];
    if( (filters & FILTER_IOS) != 0)         [types appendString:@"5,"];
    
    
    [setting setObject:types forKey:KEY_SHOW_EVENT_TYPES];
    
    [[UserModel getInstance] updateSetting:setting andCallBack:nil];
}

- (void) showSubiCalSettings:(int)row
{
    
    iCalEventShowSettingsViewController *icalSettings = [[iCalEventShowSettingsViewController alloc] initWithNibName:@"iCalEventShowSettingsViewController" bundle:nil];
    icalSettings.dismissBlock = ^(NSArray *iCalTypes){
        
        if ([iCalTypes count] != 0)
        {
            [self.calendarView.filterView changeiCalEventTypeItem:row isSelect:YES];
        }
        else
        {
            [self.calendarView.filterView changeiCalEventTypeItem:row isSelect:NO];
        }
        
    };
    [[RootNavContrller defaultInstance] pushViewController:icalSettings animated:YES];
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

-(void) onSynchronizeDataError:(int) errorCode
{
    //TOOD::
    //[dataLoadingView stopAnim];
    //[self onSynchronizeDataCompleted];
}

-(void) onSynchronizeDataCompleted
{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        if(fristLoadData) {
//            LOG_D(@"onSynchronizeDataCompleted scroll feed table to today");
//            fristLoadData = NO;
//            
//            NSDate * now = [Utils getCurrentDate];
//            NSString * day = [Utils formateDay:now];
//            [tableView scroll2SelectedDate:day];
//        }
//    });
}

-(void) onUserAccountChanged
{
    [self.calendarView.filterView updateView];
}

-(void)onEventFiltersChanged
{
    int filter = [[UserSetting getInstance] getEventfilters];
    [self.calendarView.filterView setFilter:filter];
}

- (void)uploadCalendarEvents1
{
    LOG_D(@"================start upload events=============");
    [[[Model getInstance] getEventModel] deleteIcalEvent];

}

-(void) checkAppUpdated
{
    
    [[Model getInstance] getLatestVersion:^(NSInteger error, NSDictionary *dic) {
        
        if(error != 0) return;
        
        
        NSString * latestVersion = [dic objectForKey:@"version"];
        NSString * downlaod_url = [dic objectForKey:@"download_url"];
        
        NSString *curVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
        if([curVer compare:latestVersion] < 0) {
         
            newAppVersionUrl = downlaod_url;
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"New version is available" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Update", nil];
            
            alertView.tag = 2;
            
            [alertView show];
        }
        
    }];
    
}

@end



