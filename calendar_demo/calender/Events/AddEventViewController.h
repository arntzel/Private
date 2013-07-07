
#import <UIKit/UIKit.h>
#import "Event.h"

@protocol AddEventViewDelegate <NSObject>

-(void) onEventCreated:(Event *) event;

@end

@interface AddEventViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView * indicatorView;

@property(weak, nonatomic) id<AddEventViewDelegate> delegate;

@end
