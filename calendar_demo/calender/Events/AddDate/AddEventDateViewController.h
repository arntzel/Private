
#import <UIKit/UIKit.h>
#import "EventDate.h"

@protocol AddEventDateViewControllerDelegate <NSObject>

- (void)setEventDate:(EventDate *)eventDate;

@end

@interface AddEventDateViewController : UIViewController

- (IBAction)Cancel:(id)sender;
- (IBAction)AddDate:(id)sender;

@property(nonatomic,assign) id<AddEventDateViewControllerDelegate> delegate;

@end
