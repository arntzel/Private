
#import <UIKit/UIKit.h>

@protocol AddEventInviteViewControllerDelegate <NSObject>

- (void)setInVitePeopleArray:(NSArray *)inviteArray;

@end

@interface AddEventInviteViewController : UIViewController

@property (nonatomic, assign) id<AddEventInviteViewControllerDelegate> delegate;

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (retain, nonatomic) IBOutlet UISearchBar * searchBar;

-(void) setSelectedUser:(NSArray *) selectedUsers;



@end
