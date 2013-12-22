
#import <UIKit/UIKit.h>
#import "FeedEventEntityExtra.h"
#import "UserEntityExtra.h"

#define BirthdayEventView_Height  55

@interface BirthdayEventView : UIView
@property (weak, nonatomic) IBOutlet UILabel *labTime;

@property IBOutlet UILabel * labTitle;
@property IBOutlet UIImageView * imgUser;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property IBOutlet UIImageView * imgEventType;
/*
 Update the date in the View
 */
-(void) refreshView:(FeedEventEntity *) event;

/*
 Create a EventView object with default data
 */
+(BirthdayEventView *) createEventView;


@end
