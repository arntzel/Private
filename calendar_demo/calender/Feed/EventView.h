
#import <UIKit/UIKit.h>
#import "FeedEventEntityExtra.h"
#import "UserEntityExtra.h"

#define PlanView_HEIGHT 120


/*
 A EventView in the FeedViewController
 */
@interface EventView : UIView

@property IBOutlet UILabel * labTitle;
@property IBOutlet UILabel * labAttendees;
//@property IBOutlet UILabel * labTime;
//@property IBOutlet UILabel * labTimeType;
@property (strong, nonatomic) IBOutlet UIImageView *iconLocation;
@property (strong, nonatomic) IBOutlet UIImageView *iconAttendee;
@property IBOutlet UILabel * labLocation;
@property IBOutlet UIImageView * imgUser;
@property IBOutlet UIImageView * imgStatus;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property IBOutlet UIImageView * imgEventType;
//@property IBOutlet UILabel * labEventDuration;
@property IBOutlet UILabel *labTimeStr;

/*
 Update the date in the View
 */
-(void) refreshView:(FeedEventEntity *) event;

-(float) getEventViewHeight;

/*
 Create a EventView object with default data
 */
+(EventView *) createEventView;

@end
