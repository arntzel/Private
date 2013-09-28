

#import "PedingEventViewController.h"
#import "EventPendingToolbar.h"
#import "PendingEventViewCell.h"
#import "PendingEventViewCell2.h"

#import "RootNavContrller.h"
#import "PendingTableView.h"

#import "UserModel.h"
#import "Model.h"

#import "CustomerIndicatorView.h"
#import "CoreDataModel.h"

@interface PedingEventViewController () <EventPendingToolbarDelegate, CoreDataModelDelegate>

@end

@implementation PedingEventViewController {
    EventPendingToolbar * toolbar;
    
    PendingTableView * table1;
    PendingTableView * table2;

    CustomerIndicatorView * dataLoadingView;

    //Data Model
    NSMutableArray * yourCompletedEvents;
    NSMutableArray * yourPendingEvents;
    NSMutableArray * invitedCompletedEvents;
    NSMutableArray * invitedPedingEvents;

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    yourCompletedEvents = [[NSMutableArray alloc] init];
    yourPendingEvents = [[NSMutableArray alloc] init];
    invitedCompletedEvents = [[NSMutableArray alloc] init];
    invitedPedingEvents = [[NSMutableArray alloc] init];


    self.navigation.titleLable.text = @"PENDING";
    //self.navigation.unreadCount.hidden = YES;
    
    int y = self.navigation.frame.size.height;
    
    toolbar = [EventPendingToolbar createView];
    toolbar.delegate = self;


    CGRect frame = toolbar.frame;
    frame.origin.y = y;
    toolbar.frame = frame;
    [self.view addSubview:toolbar];

    y += toolbar.frame.size.height;

    
    frame = self.view.bounds;
    frame.origin.y = y;
    frame.size.height -= y;

    table1 = [[PendingTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    table1.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //[table1 setAllowsSelection:NO];
    [table1 setSectionHeader:@"WAITING FOR FINALIZATION"];
    [self.view addSubview:table1];

    table2 = [[PendingTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    table2.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //[table2 setAllowsSelection:NO];
    [table2 setSectionHeader:@"WAITING FOR RESPONSES"];
    [self.view addSubview:table2];

    table1.hidden = NO;
    table2.hidden = YES;

  

    dataLoadingView = [[CustomerIndicatorView alloc] init];
    frame = dataLoadingView.frame;
    frame.origin.x = 320 + 40;
    frame.origin.y = 100;
    dataLoadingView.frame = frame;

    [self.view addSubview:dataLoadingView];

    [[CoreDataModel getInstance] addDelegate:self];

    [self loadData];
}

-(void) viewDidUnload
{
    [[CoreDataModel getInstance] removeDelegate:self];
    [super viewDidUnload];
}

-(void) loadData
{
    NSArray *events = [[CoreDataModel getInstance] getPendingFeedEventEntitys];
    [self resetEventsModel:events];
}

-(void) resetEventsModel: (NSArray *) events
{
    [yourCompletedEvents removeAllObjects];
    [yourPendingEvents removeAllObjects];
    [invitedCompletedEvents removeAllObjects];
    [invitedPedingEvents removeAllObjects];

    for(FeedEventEntity * evt in events) {

        if([self isMyEvent:evt]) {

            if([evt isAllAttendeeResped]) {
                [yourCompletedEvents addObject:evt];
            } else {
                [yourPendingEvents addObject:evt];
            }

        } else {

            if([evt isAllAttendeeResped]) {
                [invitedCompletedEvents addObject:evt];
            } else {
                [invitedPedingEvents addObject:evt];
            }
        }
    }

    [table1 setCompletedEvents:yourCompletedEvents andPendingEvents:yourPendingEvents];
    [table2 setCompletedEvents:invitedCompletedEvents andPendingEvents:invitedPedingEvents];

    [table1 reloadData];
    [table2 reloadData];
}

-(BOOL) isMyEvent:(FeedEventEntity *) event
{
    return [event.creatorID intValue] == [[UserModel getInstance] getLoginUser].id;
}

-(void) onButtonSelected:(int)index
{
    LOG_D(@"onButtonSelected:%d", index);
    
    if(index == 0) {
        table1.hidden = NO;
        table2.hidden = YES;
    } else {
        table1.hidden = YES;
        table2.hidden = NO;
    }
}


-(void) onCoreDataModelChanged
{
    [self loadData];
}
@end
