
#import <UIKit/UIKit.h>
#import "Event.h"

#define PlanView_HEIGHT 120


/*
 A EventView in the FeedViewController
 */
@interface EventView : UIView

@property IBOutlet UILabel * labTitle;
@property IBOutlet UILabel * labAttendees;
@property IBOutlet UILabel * labTime;
@property IBOutlet UILabel * labTimeType;
@property IBOutlet UILabel * labLocation;
@property IBOutlet UIImageView * imgUser;
@property IBOutlet UIImageView * imgStatus;
@property IBOutlet UIImageView * imgEventType;
@property IBOutlet UILabel * labEventDuration;

/*
 Update the date in the View
 */
-(void) refreshView:(Event *) event;

/*
 Create a EventView object with default data
 */
+(EventView *) createEventView;

@end
