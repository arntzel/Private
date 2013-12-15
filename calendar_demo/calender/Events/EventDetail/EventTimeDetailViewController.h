//
//  EventTimeDetailViewController.h
//  Calvin
//
//  Created by fang xiang on 13-10-12.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProposeStart.h"
#import "BaseUIViewController.h"

@interface EventTimeDetailViewController : BaseUIViewController

@property(nonatomic, retain) ProposeStart * eventTime;
@property(retain, nonatomic) UIImage *titleBgImage;

@end
