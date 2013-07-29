
#import <Foundation/Foundation.h>

@interface ViewUtils : NSObject

+(UIView *) createView:(NSString *) xibFileName;


+(int) getEventTypeColor:(int) eventType;

+(UIColor *) getUIColor:(int) argbColor;


+ (UIImage*) imageByScalingAndCroppingForSize:(CGSize)targetSize andUIImage:(UIImage *)sourceImage;


@end
