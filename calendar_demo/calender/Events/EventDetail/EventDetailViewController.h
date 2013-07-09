

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventDetailViewController : UIViewController

@property(strong) IBOutlet UIImageView * imgView;


-(IBAction) back:(id)sender;

-(void) setEvent:(Event*)event;

@end
