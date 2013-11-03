//
//  EventFilterViewCell.h
//  Calvin
//
//  Created by fangxiang on 13-11-3.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventFilterViewCell : UITableViewCell

@property IBOutlet UIImageView * colorDot;
@property IBOutlet UILabel * labelEventTypeName;
@property IBOutlet UIButton * btnSelect;

+(EventFilterViewCell *) createView:(int) eventType;

@end
