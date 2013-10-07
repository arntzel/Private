
#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"

#import "JSTokenField.h"
@protocol AddEventInviteViewControllerDelegate <NSObject>

- (void)setInVitePeopleArray:(NSArray *)inviteArray;

@end

@interface AddEventInviteViewController : BaseUIViewController

@property (nonatomic, assign) id<AddEventInviteViewControllerDelegate> delegate;

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (retain, nonatomic) IBOutlet JSTokenField * searchBar;



-(void) setSelectedUser:(NSArray *) selectedUsers;



@end
