
#import <UIKit/UIKit.h>
#import "FeedEventEntityExtra.h"
#import "UserEntityExtra.h"

#define BirthdayEventView_Height  120

@interface BirthdayEventView : UIView
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UIView *separator;

@property IBOutlet UILabel * labTitle;
@property IBOutlet UIImageView * imgUser;
@property IBOutlet UIImageView * imgEventType;

-(void) refreshView:(FeedEventEntity *) event lastForThisDay:(BOOL)lastForThisDay;

/*
 Create a EventView object with default data
 */
+(BirthdayEventView *) createEventView;


@end
