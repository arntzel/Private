
#import "UIStopWatch.h"

@implementation UIStopWatch

- (id)init 
{ 
    // if the superclass properly initializes 
    if ((self = [super init]))
    {
		startData = nil;
		[self reset];
    } // end if 
	
    return self; // return this object 
} // end method init 


- (void)dealloc
{
	//[startData release];
	
    //[super dealloc];
}

- (void)reset
{
	//[startData release];
	startData = [NSDate date];
}

- (double)getDelta
{
	double deltaTime = [[NSDate date] timeIntervalSinceDate:startData];
	[self reset];
	return deltaTime;
}


@end

