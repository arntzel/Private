

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


// file controller
@interface UIStopWatch : NSObject                                        
{
	NSDate* startData;
}

- (void)reset;
- (double)getDelta;

@end
