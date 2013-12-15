
#import <UIKit/UIKit.h>

#import "Contact.h"

@interface AddEventInvitePeople : NSObject

@property(nonatomic, retain) Contact *user;
@property(nonatomic, assign) BOOL selected;

+ (NSArray *)resortListByName:(NSArray *)contacts;
@end



@interface AddEventInvitePeopleCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView * peopleHeader;
@property (retain, nonatomic) IBOutlet UILabel * peopleName;
@property (retain, nonatomic) IBOutlet UIImageView * btnSelect;

@property (retain, nonatomic) IBOutlet UILabel * labNoData;

- (void) refreshView: (AddEventInvitePeople*) user;

- (void)setHeaderImageUrl:(NSString *)url;

@end
