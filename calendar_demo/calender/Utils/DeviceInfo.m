#import "DeviceInfo.h"
#import "SysInfo.h"

@implementation DeviceInfo

+ (float)fullScreenHeight
{
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (CGRect)fullScreenFrame
{
    CGFloat statusBarHeight = 0.0f;
    if ([SysInfo version] < 7.0) {
        if (![UIApplication sharedApplication].statusBarHidden)
        {
            statusBarHeight = 20.0f;
        }
    }

    CGRect frame = [[UIScreen mainScreen] bounds];
    //frame.size.height -= statusBarHeight;

    return frame;
}
@end
