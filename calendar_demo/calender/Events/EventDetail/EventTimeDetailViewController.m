//
//  EventTimeDetailViewController.m
//  Calvin
//
//  Created by fang xiang on 13-10-12.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "EventTimeDetailViewController.h"

#import "EventDateNavigationBar+GlassStyle.h"


#import "AddDateCalenderView.h"

#import "TimePicker.h"
#import "DuringTimePicker.h"
#import "KalLogic.h"
#import "KalView.h"

#import "EventDateNavigationBar.h"
#import "KalDate.h"

#import "EventView.h"
#import "BirthdayEventView.h"


#import "Utils.h"
#import "CoreDataModel.h"
#import "ViewUtils.h"
#import "DeviceInfo.h"

@interface EventTimeDetailViewController ()<KalViewDelegate,
                                           KalTileViewDataSource,
                                           KalTileViewDataSource,
                                           EventDateNavigationBarDelegate,
                                           UITableViewDataSource,
                                           UITableViewDelegate>
{
    KalLogic *logic;
    KalView * kalView;
    UIView * calendarView;
    
    UITableView * feedTableView;
    
    NSArray * dayEvents;
}

@end

@implementation EventTimeDetailViewController

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
	// Do any additional setup after loading the view.
    
    NSString * startTime = [Utils formateTimeAMPM: self.eventTime.start];
    NSString * endTime = [Utils formateTimeAMPM: [self.eventTime getEndTime]];
    
    NSString * time = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
    NSString * day = [Utils formateDay2:self.eventTime.start];
    
    EventDateNavigationBar * navBar = [EventDateNavigationBar creatView];
    [navBar setTitle:time];
    [navBar setDescription:day];
    [navBar setGlassImage:self.titleBgImage];
    navBar.delegate = self;
    [self.view addSubview:navBar];
    
    
    
    logic = [[KalLogic alloc] initForDate:self.eventTime.start];
    KalDate * date = [KalDate dateFromNSDate:self.eventTime.start];
    kalView = [[KalView alloc] initWithFrame:self.view.bounds delegate:nil logic:logic selectedDate:date];
    [kalView swapToMonthMode];
  
    [kalView setKalTileViewDataSource:self];

    
    [kalView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    
    calendarView = [[UIView alloc] initWithFrame:kalView.frame];
    [calendarView addSubview:kalView];
    
    [self.view addSubview:calendarView];
    
    feedTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 0) style:UITableViewStylePlain];
    feedTableView.allowsSelection = NO;
    feedTableView.backgroundColor = [UIColor whiteColor];
    feedTableView.dataSource = self;
    feedTableView.delegate = self;
    
    [self.view addSubview:feedTableView];

    [self ajustViewFrame];
    
    [self loadEvents:self.eventTime.start];
}


-(void) loadEvents: (NSDate*) date
{
    NSString * day = [Utils formateDay:date];
    
    CoreDataModel * model = [CoreDataModel getInstance];
    int filetVal = FILTER_BIRTHDAY | FILTER_FB | FILTER_IMCOMPLETE | FILTER_GOOGLE;
    dayEvents =[model getFeedEvents:day evenTypeFilter:filetVal];
    [feedTableView reloadData];
}

- (void)leftBtnPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"] && (object == kalView)) {
        [self ajustViewFrame];
    }
}

- (void)ajustViewFrame
{
    CGRect frame = kalView.frame;
    frame.origin.y = self.view.bounds.size.height - frame.size.height;
    calendarView.frame = frame;
    
    int top = 44;
    int bottom = calendarView.frame.origin.y;

    feedTableView.frame = CGRectMake(0, top, 320, bottom-top);
}

#pragma mark -
#pragma mark KalTileViewDataSource
-(int) getEventType:(KalDate *) date
{
    NSString * day = [Utils formateDay:[date NSDate]];
    int type =[[CoreDataModel getInstance] getDayFeedEventType:day];
    //type = type & tableView.eventTypeFilters;
    return type;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    if( [event.eventType intValue] != 4) {
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
    
    if([event.eventType intValue] == 4) {
        return BirthdayEventView_Height;
    } else {
        return PlanView_HEIGHT;
    }
}

@end
