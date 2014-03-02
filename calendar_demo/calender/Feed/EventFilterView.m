

#import "EventFilterView.h"
#import "EventFilterViewCell.h"
#import "UserSetting.h"
#import "UserModel.h"
#import "Event.h"
#import <EventKit/EventKit.h>
#define itemHeight 50

@interface EventTypeItem : NSObject

@property int eventType;
@property int select;

@end


@implementation EventTypeItem


@end

@implementation EventFilterView {

    
    NSMutableArray * eventTypeItems;

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id) init {
    
    self = [super initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //self.backgroundColor = [UIColor whiteColor];
    //self.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:.5f];
    
    self.dataSource = self;
    self.delegate = self;
    
    [self updateView];
    
   
    return self;
}


-(void) updateView
{
    NSString * allTypes ;
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    if (status == EKAuthorizationStatusAuthorized)
    {
        allTypes = @"0,1,3,4,5";
    }
    else
    {
        allTypes = @"0,1,3,4";
    }
    NSMutableArray * neweventTypeItems = [[NSMutableArray alloc] init];
    
    User * me = [[UserModel getInstance] getLoginUser];
    
    NSArray * types = [allTypes componentsSeparatedByString:@","];
    for(NSString * strType in types) {
        EventTypeItem * item = [[EventTypeItem alloc] init];
        item.eventType = [strType intValue];
        
        if ((item.eventType == 3 || item.eventType == 4))
        {
            if (![me isFacebookConnected])
                continue;
        }
        
        if (item.eventType == 1 && ![me isGoogleConnected])
        {
            continue;
        }
        
        EventTypeItem * oldItem = [self getEventTypeItem:item.eventType];
        if(oldItem == nil) {
            item.select = YES;
        } else {
            item.select = oldItem.select;
        }
        
        [neweventTypeItems addObject:item];
    }
    
    eventTypeItems = neweventTypeItems;
    
    self.frame = CGRectMake(0, 0, 320, eventTypeItems.count * itemHeight);
    
    [self onFilterChanged];
}

- (CGFloat)displayHeight
{
    NSInteger displayItemNumber = eventTypeItems.count > 3 ? 3:eventTypeItems.count;
    
    return displayItemNumber *itemHeight;
}

-(EventTypeItem *) getEventTypeItem:(int) type
{
    if(eventTypeItems == nil) return nil;
    
    for(EventTypeItem * item in eventTypeItems)
    {
        if(item.eventType == type) return item;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return eventTypeItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventTypeItem *item = [eventTypeItems objectAtIndex:indexPath.row];
    EventFilterViewCell * cell = [EventFilterViewCell createView:item.eventType];
    cell.btnSelect.selected = item.select;
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    
    if (item.eventType == 5)
    {
        __weak EventFilterViewCell *weakCell = cell;
        weakCell.btnSelect.userInteractionEnabled = YES;
        weakCell.btnBeClickedBlock = ^{
        
            item.select = !item.select;
            cell.btnSelect.selected = item.select;
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            if (item.select)
            {
                NSMutableArray *iCalTypes = [[NSMutableArray alloc] init];
                EKEventStore *store = [[EKEventStore alloc] init];
                NSArray *iCals = [store calendarsForEntityType:EKEntityTypeEvent];
                for (EKCalendar *iCal in iCals)
                {
                    
                    [iCalTypes addObject:iCal.calendarIdentifier];
                    
                }
                [userDefaults setObject:iCalTypes forKey:@"iCalTypes"];
                
            }
            else
            {
                [userDefaults removeObjectForKey:@"iCalTypes"];
            }
            [userDefaults synchronize];
            
            [self onFilterChanged];
        };
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     EventTypeItem *item = [eventTypeItems objectAtIndex:indexPath.row];
    if (item.eventType == 5)
    {
        if ([self.filterDelegate respondsToSelector:@selector(showSubiCalSettings:)])
        {
            
            [self.filterDelegate showSubiCalSettings:indexPath.row];
        }
    }
    else
    {
        item.select = !item.select;
        [self onFilterChanged];
    }
    
}

-(void) onFilterChanged
{
    int filters = 0;
    
    for(EventTypeItem * eventTypeItem in eventTypeItems)
    {
        if(eventTypeItem.select) {
            filters |=  (0x00000001 << eventTypeItem.eventType);
        }
    }
    [self.filterDelegate onFilterChanged:filters];
    [self reloadData];

}

-(void) setFilter:(int) filter
{
    for(EventTypeItem * item in eventTypeItems) {
        int type = 0x00000001 << item.eventType;
        item.select = (filter & type) > 0;
        
    }
    
    [self reloadData];
}

-(void)changeiCalEventTypeItem:(int)row isSelect:(BOOL)yesOrNo
{
    EventTypeItem *item = [eventTypeItems objectAtIndex:row];
    item.select = yesOrNo;
    [self onFilterChanged];
}
@end
