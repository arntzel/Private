
#import <UIKit/UIKit.h>
#import "EventDate.h"
#import "BaseUIViewController.h"


@protocol AddEventDateViewControllerDelegate <NSObject>

- (void)setEventDate:(EventDate *)eventDate;

@end

@interface AddEventDateViewController : BaseUIViewController

- (id)initWithEventDate:(EventDate *)arrangedDate;

@property(nonatomic,assign) id<AddEventDateViewControllerDelegate> delegate;

@end
