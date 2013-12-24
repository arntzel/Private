

#import <UIKit/UIKit.h>


@protocol EventFilterViewDelegate <NSObject>

-(void) onFilterChanged:(int)filters;
- (void) showSubiCalSettings:(int)row;
@end


@interface EventFilterView  : UITableView <UITableViewDataSource, UITableViewDelegate>

-(void) setFilter:(int) filter;

-(void) updateView;

-(void)changeiCalEventTypeItem:(int)row isSelect:(BOOL)yesOrNo;
@property(nonatomic, assign) id<EventFilterViewDelegate> filterDelegate;

- (CGFloat)displayHeight;

@end
