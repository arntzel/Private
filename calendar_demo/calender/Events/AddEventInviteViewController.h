
#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"


@protocol AddEventInviteViewControllerDelegate <NSObject>

- (void)setInVitePeopleArray:(NSArray *)inviteArray;

@end

@interface AddEventInviteViewController : BaseUIViewController

@property (nonatomic, assign) id<AddEventInviteViewControllerDelegate> delegate;

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (retain, nonatomic) IBOutlet UISearchBar * searchBar;

-(void) setSelectedUser:(NSArray *) selectedUsers;



@end
