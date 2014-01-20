#import <UIKit/UIKit.h>
#import "AEEntryViewProtocal.h"


@interface AEInviteesEntry : UIView

@property(nonatomic,weak) id<AEEntryViewProtocal> delegate;
+(AEInviteesEntry *) createView;

@end
