
#import "Event.h"
#import <UIKit/UIKit.h>

@interface PendingEventViewCell : UITableViewCell

@property IBOutlet UIImageView * imgView;
@property IBOutlet UILabel * labelTitle;
@property IBOutlet UILabel * labelAttendees;
@property IBOutlet UILabel * lableFinalTime;

@property IBOutlet UILabel * lableEmpty;


-(void) refreshView:(Event*) event;


+(PendingEventViewCell *) createView;


@end
