//
//  UIStopWatch.h
//
//  Created by Elton Liu on 6/29/12.
//	Copyright (c) 2012 Moxtra, Inc.	All rights reserved.
//

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
