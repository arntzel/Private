//
//  PedingEventViewControllerNew.m
//  Calvin
//
//  Created by Yevgeny on 2/23/14.
//  Copyright (c) 2014 Pencil Me, Inc. All rights reserved.
//

#import "PedingEventViewControllerNew.h"
#import "PendingEventViewCell2.h"
#import "RootNavContrller.h"
#import "PendingTableView.h"
#import "UserModel.h"
#import "Model.h"
#import "CustomerIndicatorView.h"
#import "CoreDataModel.h"
#import "EventDetailController.h"
#import "RootNavContrller.h"
#import "ViewUtils.h"
#import "PendingCell.h"

@interface PedingEventViewControllerNew() <UITableViewDataSource, UITableViewDelegate, PopDelegate>

@end

@implementation PedingEventViewControllerNew {
    
    UITableView * table1;
    
    CustomerIndicatorView * dataLoadingView;
    
    NSMutableArray * rsvpEvents;
    NSMutableArray * myEvents;
}

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
    
    rsvpEvents = [[NSMutableArray alloc] init];
    myEvents = [[NSMutableArray alloc] init];
    
    self.navigation.calPendingSegment.hidden = NO;
    [self.navigation.calPendingSegment addTarget:self.delegate action:@selector(onSegmentPressed:) forControlEvents:UIControlEventValueChanged];
    self.navigation.titleLable.text = @"PENDING";
    
    int y = self.navigation.frame.size.height;
    
    CGRect frame = self.view.bounds;
    frame.origin.y = y;
    frame.size.height -= y;
    
    table1 = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    table1.separatorStyle = UITableViewCellSeparatorStyleNone;
    table1.dataSource = self;
    table1.delegate = self;
    
    [table1 registerNib:[UINib nibWithNibName:@"PendingCell" bundle:nil] forCellReuseIdentifier:@"PendingCell"];
    
    [self.view addSubview:table1];
    
    dataLoadingView = [[CustomerIndicatorView alloc] init];
    frame = dataLoadingView.frame;
    frame.origin.x = 320 + 40;
    frame.origin.y = 100;
    dataLoadingView.frame = frame;
    
    [self.view addSubview:dataLoadingView];
}

-(void) viewDidUnload
{
    [super viewDidUnload];
}

-(void) viewWillAppear:(BOOL)animated
{
    NSLog(@"PedingEventViewController viewWillAppear");
    
    if (self.navigation) {
        [self.navigation.calPendingSegment setSelectedSegmentIndex:1];
    }
    
    [self loadData];
}

-(void) onCoreDataModelStarted
{
}

-(void) onCoreDataModelChanged
{
    [self loadData];
}

-(void) loadData
{
    NSArray *events = [[CoreDataModel getInstance] getPendingFeedEventEntitys];
    
    NSMutableArray * array = [[NSMutableArray alloc] init];
    
    BOOL needSavaDB = NO;
    
    for(FeedEventEntity * evt in events) {
        
        if ([evt isHistory]) {
            
            int evtID = [evt.id intValue];
            
            LOG_I(@"Delete history Event: %d %@, %@, %@",  evtID, evt.title, evt.maxProposeStarTime, evt.eventType);
            
            [[CoreDataModel getInstance] deleteFeedEventEntity:evtID];
            needSavaDB = YES;
            
        } else {
            [array addObject:evt];
        }
    }
    
    if(needSavaDB) {
        [[CoreDataModel getInstance] saveData];
    }
    [self resetEventsModel:array];
}

-(void) resetEventsModel: (NSArray *) events
{
    [rsvpEvents removeAllObjects];
    [myEvents removeAllObjects];
    
    for(FeedEventEntity * evt in events) {

        if ([self isMyEvent:evt]) {
            
            if ([evt isAllAttendeeResped]) {
                [myEvents addObject:evt];
            } else {
                [myEvents addObject:evt];
            }
        }
        else {
            
            if ([evt isAllAttendeeResped]) {
                [rsvpEvents addObject:evt];
            } else {
                [rsvpEvents addObject:evt];
            }
        }
    }
    
    [table1 reloadData];
}

-(BOOL) isMyEvent:(FeedEventEntity *) event
{
    return [event.creatorID intValue] == [[UserModel getInstance] getLoginUser].id;
}

#pragma mark -
#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * eventList = [self getEventsList:section];
    int rows = eventList.count;
    
    return rows > 0 ? rows : 1;
}

-(NSArray *) getEventsList:(int)section
{
    NSArray * array = nil;
    if (section == 0) {
        array = rsvpEvents;
    }
    if (section == 1) {
        array = myEvents;
    }
    return array;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;
    
    NSArray * eventList = [self getEventsList:section];
    
    if (eventList.count == 0)
    {
        return (UITableViewCell *)[ViewUtils createView:@"PendingEventViewNoEventCell"];
    }
    
    FeedEventEntity * evt = [eventList objectAtIndex:row];
    
	PendingCell *c = (PendingCell*)[tableView dequeueReusableCellWithIdentifier:@"PendingCell"];
    [c setSelectionStyle:UITableViewCellSelectionStyleGray];

    BOOL last = NO;
    if (indexPath.row >= [eventList count]-1)
        last = YES;
    
    [c refreshView:evt lastForThisDay:last];
    
    return c;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * header = [ViewUtils createView:@"PendingEventsSectionHeader"];
    UILabel * label =  (UILabel *) [header viewWithTag:1];
    
    if (section == 0) {
        label.text = @"RSVP";
    }
    if (section == 1) {
        label.text = @"YOUR EVENTS";
    }
    
    return header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;//60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LOG_D(@"tableView:didSelectRowAtIndexPath:%@", indexPath);
    
    int section = indexPath.section;
    int row = indexPath.row;
    
    NSArray * eventList = [self getEventsList:section];
    
    if (eventList.count > 0) {
        FeedEventEntity * event = [eventList objectAtIndex:row];
        
        if ([event isCalvinEvent] ) {
            
            EventDetailController * detailCtl = [[EventDetailController alloc] init];
            detailCtl.popDelegate = self;
            detailCtl.eventID = [event.id intValue];
            [[RootNavContrller defaultInstance] pushViewController:detailCtl animated:YES];
        }
    }
}

-(void)onControlledPopped:(BOOL)dataChanged
{
    [table1 reloadData];
    [self.popDelegate onControlledPopped:dataChanged];
}

@end
