
#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"
#import "Event.h"

@protocol DetailInviteesControllerDelegate <NSObject>

- (void)setInVitePeopleArray:(NSArray *)inviteArray;

@end

@interface DetailInviteesController : BaseUIViewController

@property (nonatomic, assign) id<DetailInviteesControllerDelegate> delegate;

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic, retain) Event * event;

@end
