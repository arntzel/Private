
#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"

@protocol AddEventInviteViewControllerDelegate <NSObject>

- (void)setInVitePeopleArray:(NSArray *)inviteArray;

@end

typedef enum
{
    AddInviteeTypeAll,  //add add invite
    AddInviteeTypeRest  //detail add invite
}AddInviteeType;

@interface AddEventInviteViewController : BaseUIViewController

@property (nonatomic, assign) id<AddEventInviteViewControllerDelegate> delegate;

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

-(void) setSelectedUser:(NSArray *) selectedUsers;

@property(nonatomic,assign) AddInviteeType type;

@end
