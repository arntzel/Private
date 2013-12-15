#import "navigationNotifySectionHeader.h"

@implementation navigationNotifySectionHeader

- (void)dealloc {
    [_title release];
    self.loadingView = nil;
    [super dealloc];
}

@end
