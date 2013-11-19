

#import "EventFilterView.h"
#import "EventFilterViewCell.h"
#import "UserSetting.h"
#import "UserModel.h"
#import "Event.h"

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
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.dataSource = self;
    self.delegate = self;
    
    [self updateView];
    
   
    return self;
}


-(void) updateView
{
    NSString * allTypes = @"0,1,3,4,5";
    
    NSMutableArray * neweventTypeItems = [[NSMutableArray alloc] init];
    
    User * me = [[UserModel getInstance] getLoginUser];
    
    NSArray * types = [allTypes componentsSeparatedByString:@","];
    for(NSString * strType in types) {
        EventTypeItem * item = [[EventTypeItem alloc] init];
        item.eventType = [strType intValue];
        
        if( (item.eventType == 3 || item.eventType == 4) && ![me isFacebookConnected])
        {
            continue;
        }
        
        if(item.eventType == 1 && ![me isGoogleConnected])
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
    
    self.frame = CGRectMake(0, 0, 320, neweventTypeItems.count * 50);
    
    [self onFilterChanged];
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
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     EventTypeItem *item = [eventTypeItems objectAtIndex:indexPath.row];
    item.select = !item.select;
    
    [self onFilterChanged];
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

@end
