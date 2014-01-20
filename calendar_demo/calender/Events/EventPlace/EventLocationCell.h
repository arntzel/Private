//
//  EventLocationCell.h
//  Calvin
//
//  Created by fangxiang on 14-1-15.
//  Copyright (c) 2014年 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventLocationCell : UITableViewCell

@property(retain, nonatomic) IBOutlet UILabel * name;
@property(retain, nonatomic) IBOutlet UILabel * address;

+(EventLocationCell *) creatView;

@end
