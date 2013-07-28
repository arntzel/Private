
#import <Foundation/Foundation.h>

@interface ViewUtils : NSObject

+(UIView *) createView:(NSString *) xibFileName;


+(int) getEventTypeColor:(int) eventType;

+(UIColor *) getUIColor:(int) argbColor;

@end
