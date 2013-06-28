
#import <UIKit/UIKit.h>
#import "Event.h"

@interface YourEventCell : UIView

@property IBOutlet UIImageView * imgView;
@property IBOutlet UILabel * labelTitle;
@property IBOutlet UILabel * labelAttendees;
@property IBOutlet UILabel * lableFinalTime;


-(void) refreshView:(Event*) event;


+(YourEventCell *) createView;

@end
