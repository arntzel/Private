
#import <UIKit/UIKit.h>

#import "User.h"

@interface AddEventInvitePeople : NSObject

@property(nonatomic, retain) User *user;
@property(nonatomic, assign) BOOL selected;


@end



@interface AddEventInvitePeopleCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView * peopleHeader;
@property (retain, nonatomic) IBOutlet UILabel * peopleName;
@property (retain, nonatomic) IBOutlet UIImageView * btnSelect;

@property (retain, nonatomic) IBOutlet UILabel * labNoData;

- (void) refreshView: (AddEventInvitePeople*) user;


@end