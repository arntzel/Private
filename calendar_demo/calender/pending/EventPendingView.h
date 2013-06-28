

#import <UIKit/UIKit.h>

@interface EventPendingView : UIView

@property IBOutlet UISegmentedControl * segmentedControl;

@property IBOutlet UITableView * table1;
@property IBOutlet UITableView * table2;



+(EventPendingView*) createView;

@end
