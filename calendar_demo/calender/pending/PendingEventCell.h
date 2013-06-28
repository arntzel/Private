
#import <UIKit/UIKit.h>
#import "Event.h"

@interface PendingEventCell : UIView

@property IBOutlet UIImageView * imgView;
@property IBOutlet UILabel * labelTitle;
@property IBOutlet UILabel * labelAttendees;
@property IBOutlet UILabel * lableLocation;
@property IBOutlet UILabel * lableResponsed;


-(void) refreshView:(Event*) event;

+(PendingEventCell *) createView;

@end
