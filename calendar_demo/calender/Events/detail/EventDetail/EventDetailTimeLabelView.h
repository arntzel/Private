//
//  EventDetailTimeLabelView.h
//  detail
//
//  Created by zyax86 on 13-8-3.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailTimeLabelView : UIView

+(EventDetailTimeLabelView *) creatView;
@property (retain, nonatomic) IBOutlet UILabel *title;

@end
