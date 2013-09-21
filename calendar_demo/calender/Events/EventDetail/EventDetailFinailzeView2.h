//
//  EventDetailFinailzeView2.h
//  Calvin
//
//  Created by xiangfang on 13-9-21.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailFinailzeView2 : UIView

@property (retain, nonatomic) IBOutlet UILabel *eventTimeLabel;
@property (retain, nonatomic) IBOutlet UIView *contentView;

+(EventDetailFinailzeView2 *) creatView;

@end
