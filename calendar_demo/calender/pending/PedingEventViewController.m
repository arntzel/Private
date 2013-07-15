

#import "PedingEventViewController.h"
#import "EventPendingToolbar.h"
#import "PendingEventViewCell.h"
#import "PendingEventViewCell2.h"

#import "RootNavContrller.h"
#import "PendingTableView.h"

#import "UserModel.h"
#import "Model.h"

@interface PedingEventViewController () <PullRefreshTableViewDelegate, EventPendingToolbarDelegate>

@end

@implementation PedingEventViewController {
    EventPendingToolbar * toolbar;
    
    PendingTableView * table1;
    PendingTableView * table2;

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
    self.navigation.unreadCount.hidden = YES;
    
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
    [table1 setAllowsSelection:NO];
    [table1 setSectionHeader:@"WAITING FOR FINALIZATION"];
    [self.view addSubview:table1];

    table2 = [[PendingTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    table2.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [table2 setAllowsSelection:NO];
    [table2 setSectionHeader:@"WAITING FOR RESPONSES"];
    [self.view addSubview:table2];

    table1.hidden = NO;
    table2.hidden = YES;

    table1.pullRefreshDalegate = self;
    table2.pullRefreshDalegate = self;

    [table1 startHeaderLoading];
    
}

-(void) loadData
{
    //[indicator startAnimating];

    [[Model getInstance] getEventsOfPending:^(NSInteger error, NSArray *events) {
        //[indicator stopAnimating];
        LOG_D(@"getEventsOfPending callback");

        if(error == 0) {

            [self resetEventsModel:events];

        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                            message:@"network or server error!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];

            [alert show];
        }

        [table1 stopPullLoading];
        [table2 stopPullLoading];
    }];

}

-(void) resetEventsModel: (NSArray *) events
{
    [yourCompletedEvents removeAllObjects];
    [yourPendingEvents removeAllObjects];
    [invitedCompletedEvents removeAllObjects];
    [invitedPedingEvents removeAllObjects];

    for(int i=0; i<events.count;i++) {

        Event * evt = [events objectAtIndex:i];

        if([self isMyEvent:evt]) {

            if([evt isPendingStatus]) {
                [yourPendingEvents addObject:evt];
            } else {
                [yourCompletedEvents addObject:evt];
            }

        } else {

            if([evt isPendingStatus]) {
                [invitedPedingEvents addObject:evt];
            } else {
                [invitedCompletedEvents addObject:evt];
            }
        }
    }

    [table1 setCompletedEvents:yourCompletedEvents andPendingEvents:yourPendingEvents];
    [table2 setCompletedEvents:invitedCompletedEvents andPendingEvents:invitedPedingEvents];

    [table1 reloadData];
    [table2 reloadData];
}

-(BOOL) isMyEvent:(Event *) event
{
    return event.creator.id == [[UserModel getInstance] getLoginUser].id;
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


#pragma mark -
#pragma mark PullRefreshTableViewDelegate
- (void) onPullStarted {
    
}

- (void) onPullCancelled {
    
}

-(void) onStartLoadData
{
    [self loadData];
}

-(void) onPullStop {
    
}
@end
