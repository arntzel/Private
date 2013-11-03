

#import <UIKit/UIKit.h>


@protocol EventFilterViewDelegate <NSObject>

-(void) onFilterChanged:(int)filters;

@end


@interface EventFilterView  : UITableView <UITableViewDataSource, UITableViewDelegate>

-(void) setFilter:(int) filter;


@property(nonatomic, assign) id<EventFilterViewDelegate> filterDelegate;


@end
