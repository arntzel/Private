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
#import "EventViewCell.h"
#import "FeedEventTableViewCell.h"

@interface EventTimeDetailViewController ()<EventDateNavigationBarDelegate,
                                           UITableViewDataSource,
                                           UITableViewDelegate>
{
    UITableView * feedTableView;
    NSArray * events;
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
    
    
    CGRect frame = self.view.frame;
    frame.origin.y = [navBar getMaxY];
    frame.size.height -= frame.origin.y;
    feedTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    
    [feedTableView registerNib:[UINib nibWithNibName:@"NoEventsCell" bundle:nil] forCellReuseIdentifier:@"NoEventsCell"];
    [feedTableView registerNib:[UINib nibWithNibName:@"EventViewCell" bundle:nil] forCellReuseIdentifier:@"EventViewCell"];
    
    
    feedTableView.allowsSelection = NO;
    feedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    feedTableView.dataSource = self;
    feedTableView.delegate = self;
    
    UIView *bgview = [[UIView alloc] initWithFrame: feedTableView.frame];
    bgview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"feed_background_image.png"]];
    feedTableView.backgroundView = bgview;

    
    [self.view addSubview:feedTableView];

    
    [self loadEvents];
}


-(void) loadEvents
{
    CoreDataModel * model = [CoreDataModel getInstance];
    NSDate * startDate = [self.eventTime.start cc_dateByMovingToBeginningOfDay];
    NSDate * endDate = [[self.eventTime getEndTime] cc_dateByMovingToEndOfDay];
    events = [model getDayFeedEventEntitys:startDate andEndDate:endDate];
 
    [feedTableView reloadData];
}

- (void)leftBtnPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(events == nil || events.count == 0) {
        return 1;
    }
    
    return events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(events == nil || events.count == 0) {
        UITableViewCell * cell = (UITableViewCell*)[ViewUtils createView:@"NoEventsCell"];
        return cell;
    }
    
    
    FeedEventEntity * event = [events objectAtIndex:indexPath.row];
    
    
    int row = indexPath.row;
    
    BOOL lastForThisDay = (row == (events.count-1));
    
    EventViewCell *cell = (EventViewCell*)[tableView dequeueReusableCellWithIdentifier:@"EventViewCell"];
    [cell refreshView:event lastForThisDay:lastForThisDay];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if(lastForThisDay) {
    
        CGRect frame = cell.frame;
        frame.origin.y = frame.size.height -1;
        frame.size.height = 1;
        
        UIView * line = [[UIView alloc] initWithFrame:frame];
        line.backgroundColor = [UIColor grayColor];
        [cell addSubview:line];
        
    }
    
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(events == nil || events.count == 0) {
        return 87;
    }
    
    int row = indexPath.row;
    
    FeedEventEntity * event = [events objectAtIndex:row];
    
    if ([event isBirthdayEvent] ) {
        return 87;//BirthdayEventView_Height;
    }
    else {
        //NSString *eventTitle = event.title;
#if 0
        CGSize maxSize = CGSizeMake(270.0, 1000.0f);
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        CGSize fontSize = [event.title sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
        return fontSize.height + 85;
#endif
        return 87;//76;//87;
    }

}


@end
