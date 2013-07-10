
#import <UIKit/UIKit.h>
#import "EventDate.h"

@protocol AddEventDateViewControllerDelegate <NSObject>

- (void)setEventDate:(EventDate *)eventDate;

@end

@interface AddEventDateViewController : UIViewController

- (id)initWithEventDate:(EventDate *)arrangedDate;

@property(nonatomic,assign) id<AddEventDateViewControllerDelegate> delegate;

@end
