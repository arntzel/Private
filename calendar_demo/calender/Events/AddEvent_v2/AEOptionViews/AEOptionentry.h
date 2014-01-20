#import <UIKit/UIKit.h>
#import "AEEntryViewProtocal.h"

@interface AEOptionentry : UIView

@property(nonatomic,weak) id<AEEntryViewProtocal> delegate;
+(AEOptionentry *) createView;
@end
