
#import "ViewUtils.h"
#import "Utils.h"

@implementation ViewUtils


+(UIView *) createView:(NSString *) xibFileName
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:xibFileName owner:self options:nil];
    return [nibView objectAtIndex:0];
}

+(int) getEventTypeColor:(int) eventType
{
    int color;

    switch (eventType) {
        case 0:
            color = 0xFFF44258;
            break;

        case 1:
            color = 0xFFD5AD3E;
            break;

        case 2:
            color = 0xFFAAA9AE;
            break;

        case 3:
            color = 0xFF477DBD;
            break;

        case 4:
            color = 0xFF71A189;
            break;

        case 5:
            color = 0xFFB34BAC;
            break;

        default:
            color = 0x00000000;
            break;
    }

    return color;
}


+(UIColor *) getUIColor:(int) argbColor
{
    float r = COLOR_R(argbColor)/255.0;
    float g = COLOR_G(argbColor)/255.0;
    float b = COLOR_B(argbColor)/255.0;
    float a = COLOR_A(argbColor)/255.0;

    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}
@end
