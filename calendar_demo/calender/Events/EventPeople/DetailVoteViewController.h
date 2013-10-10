
#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"
#import "Event.h"

@interface DetailVoteViewController : BaseUIViewController

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@property(retain, nonatomic) Event * event;
@property(retain, nonatomic) ProposeStart * eventTime;

@end
