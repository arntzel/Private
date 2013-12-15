#import "SharePhotoBase.h"
#import <FacebookSDK/FacebookSDK.h>
@interface SharePhotoFacebook : SharePhotoBase<FBLoginViewDelegate>
@property (strong, nonatomic) FBRequestConnection *connect;

@end
