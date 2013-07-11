
#import "ViewUtils.h"

@implementation ViewUtils


+(UIView *) createView:(NSString *) xibFileName
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:xibFileName owner:self options:nil];
    return [nibView objectAtIndex:0];
}

@end
