
#import "Event.h"
#import <UIKit/UIKit.h>

@interface PendingEventViewCell2 : UITableViewCell

@property IBOutlet UIImageView * imgView;
@property IBOutlet UILabel * labelTitle;
@property IBOutlet UILabel * labelAttendees;

@property IBOutlet UILabel * lableEmpty;



-(void) refreshView:(Event*) event;


+(PendingEventViewCell2 *) createView;


@end
