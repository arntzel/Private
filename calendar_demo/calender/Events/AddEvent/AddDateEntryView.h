//
//  AddDateEntryView.h
//  test
//
//  Created by zyax86 on 13-7-7.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDateEntryView : UIView
@property (retain, nonatomic) IBOutlet UIImageView *DateResultView;
@property (retain, nonatomic) IBOutlet UIImageView *AddDateView;

@property (retain, nonatomic) IBOutlet UIButton *btnAddDate;

+(AddDateEntryView *) createDateEntryView;

@property (retain, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *duringTimeLabel;

@end
