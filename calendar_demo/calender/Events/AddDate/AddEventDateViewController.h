
#import <UIKit/UIKit.h>
#import "ProposeStart.h"
#import "BaseUIViewController.h"


@protocol AddEventDateViewControllerDelegate <NSObject>

- (void)setEventDate:(ProposeStart *)eventDate;

@optional
- (void)updateEventDate:(ProposeStart *)eventDate;

@end

@interface AddEventDateViewController : BaseUIViewController

- (id)initWithEventDate:(ProposeStart *)arrangedDate;

@property(nonatomic,assign) id<AddEventDateViewControllerDelegate> delegate;
@property(nonatomic,assign) BOOL isUpdate;

@end
