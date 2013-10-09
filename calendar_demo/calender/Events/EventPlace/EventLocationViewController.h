//
//  EventLocationViewController.h
//  Calvin
//
//  Created by zyax86 on 10/5/13.
//  Copyright (c) 2013 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"

@interface EventLocationViewController : BaseUIViewController

- (void)updatePlaceWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude;

@end
