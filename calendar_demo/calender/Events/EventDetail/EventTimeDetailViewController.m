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
#import "Model.h"
#import "CoreDataModel.h"
#import "ViewUtils.h"
#import "DeviceInfo.h"

#import "NSDateAdditions.h"
#import "UIView+FrameResize.h"

@interface EventTimeDetailViewController ()<EventDateNavigationBarDelegate,
                                           UITableViewDataSource,
                                           UITableViewDelegate>
{
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
	
    NSString * time =  [Utils getProposeStatLabel:self.eventTime];
    NSString * day = [Utils formateDay2:self.eventTime.start];
    
    EventDateNavigationBar * navBar = [EventDateNavigationBar creatView];
    [navBar setTitle:time];
    [navBar setDescription:day];
    [navBar setGlassImage:self.titleBgImage];
    navBar.delegate = self;
    [self.view addSubview:navBar];
    
    
    //TODO:: Xiang convertLocalDate is need?
    //NSDate * localeDate = [Utils convertLocalDate:self.eventTime.start];
    NSDate * localeDate = [self.eventTime.start cc_dateByMovingToBeginningOfDay];
    
    
    CGRect frame = self.view.frame;
    frame.origin.y = [navBar getMaxY];
    frame.size.height -= frame.origin.y;
    feedTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    feedTableView.allowsSelection = NO;
    feedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    feedTableView.backgroundColor = [UIColor whiteColor];
    feedTableView.dataSource = self;
    feedTableView.delegate = self;
    
    UIView *bgview = [[UIView alloc] initWithFrame: feedTableView.frame];
    bgview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"feed_background_image.png"]];
    feedTableView.backgroundView = bgview;

    
    [self.view addSubview:feedTableView];

    
    [self loadEvents:localeDate];
}


-(void) loadEvents: (NSDate*) date
{
    NSString * day = [Utils formateDay:date];
    
    CoreDataModel * model = [CoreDataModel getInstance];
    int filetVal = FILTER_BIRTHDAY | FILTER_FB | FILTER_IMCOMPLETE | FILTER_GOOGLE|FILTER_IOS;
    dayEvents =[model getFeedEvents:day evenTypeFilter:filetVal];
    [feedTableView reloadData];
}

- (void)leftBtnPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
        UITableViewCell * cell = (UITableViewCell*)[ViewUtils createView:@"NoEventsCell"];
        return cell;
    }
    
    FeedEventEntity * event = [dayEvents objectAtIndex:indexPath.row];
    
    if( ![event isBirthdayEvent] ) {
        EventView * view = [EventView createEventView];
        
        [view refreshView:event lastForThisDay:NO];
        
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eventView"];
        [cell addSubview:view];
        return cell;
        
    } else {
        BirthdayEventView * view = [BirthdayEventView createEventView];
        
        [view refreshView:event lastForThisDay:NO];
        
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
    
    if([event isBirthdayEvent] ) {
        return BirthdayEventView_Height;
    } else {
        return PlanView_HEIGHT;
    }
}

@end
