//
//  CustomPickerCell.h
//  AddDate
//
//  Created by zyax86 on 13-6-23.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPickerCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *labValue;

@property (assign, nonatomic) CGFloat labelWidth;

- (void)initUI;

@end
