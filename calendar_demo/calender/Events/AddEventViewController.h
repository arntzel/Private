
#import <UIKit/UIKit.h>
#import "Event.h"

@protocol AddEventViewDelegate <NSObject>

-(void) onEventCreated:(Event *) event;

@end

@interface AddEventViewController : UIViewController

@property(weak, nonatomic) id<AddEventViewDelegate> delegate;
@end
