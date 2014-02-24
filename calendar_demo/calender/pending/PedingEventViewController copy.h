#import <UIKit/UIKit.h>

#import "BaseMenuViewController.h"
#import "CoreDataModel.h"

@interface PedingEventViewController : BaseMenuViewController <CoreDataModelDelegate>

@property(assign) id<PopDelegate> popDelegate;

@end
