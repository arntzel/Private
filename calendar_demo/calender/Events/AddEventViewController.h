
#import <UIKit/UIKit.h>
#import "Event.h"

@protocol AddEventViewDelegate <NSObject>

-(void) onEventCreated:(Event *) event;

@end

@interface AddEventViewController : UIViewController

@property(retain, nonatomic) UIActivityIndicatorView * indicatorView;

@property(assign, nonatomic) id<AddEventViewDelegate> delegate;
@end
