#import <UIKit/UIKit.h>
#import "AEEntryViewProtocal.h"

@interface AETimeEntry : UIView

@property(nonatomic,weak) id<AEEntryViewProtocal> delegate;
+(AETimeEntry *) createView;

- (void)setTitleText:(NSString *)title;
@end
