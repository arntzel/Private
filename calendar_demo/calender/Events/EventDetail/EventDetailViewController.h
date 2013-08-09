

#import <UIKit/UIKit.h>
#import "Event.h"
#import "BaseUIViewController.h"

@interface EventDetailViewController : BaseUIViewController

@property(strong) IBOutlet UIImageView * imgView;


-(IBAction) back:(id)sender;

-(void) setEvent:(Event*)event;

-(void) setEventID:(int)eventID;

@end
