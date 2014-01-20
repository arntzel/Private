#import <UIKit/UIKit.h>
#import "AEEntryViewProtocal.h"

@interface AELocalEntry : UIView

@property(nonatomic,weak) id<AEEntryViewProtocal> delegate;
+(AELocalEntry *) createView;
@end
