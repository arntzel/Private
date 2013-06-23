//
//  EventPendingView.h
//  calender
//
//  Created by xiangfang on 13-6-23.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventPendingView : UIView

@property IBOutlet UISegmentedControl * segmentedControl;

@property IBOutlet UITableView * table1;
@property IBOutlet UITableView * table2;



+(EventPendingView*) createView;

@end
