
#import <Foundation/Foundation.h>

@interface ViewUtils : NSObject

+(UIView *) createView:(NSString *) xibFileName;


+(int) getEventTypeColor:(int) eventType;

+(NSString *) getEventTypeName:(int) eventType;

+(UIColor *) getUIColor:(int) argbColor;


+ (UIImage*) imageByScalingAndCroppingForSize:(CGSize)targetSize andUIImage:(UIImage *)sourceImage;

+(void) resetUILabelFont:(UIView *)view;

@end
