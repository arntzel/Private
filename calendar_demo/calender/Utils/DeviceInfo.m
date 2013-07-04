#import "DeviceInfo.h"

@implementation DeviceInfo
+ (float)fullScreenHeight
{
    CGFloat statusBarHeight = 0.0f;
    if (![UIApplication sharedApplication].statusBarHidden)
    {
        statusBarHeight = 20.0f;
    }
    return [[UIScreen mainScreen] bounds].size.height - statusBarHeight;
}
@end
