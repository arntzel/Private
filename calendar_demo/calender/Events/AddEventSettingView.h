//
//  AddEventSettingView.h
//  test
//
//  Created by zyax86 on 13-7-7.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddEventSettingView : UIView
@property (retain, nonatomic) IBOutlet UIImageView *view1;
@property (retain, nonatomic) IBOutlet UIImageView *view2;
@property (retain, nonatomic) IBOutlet UIImageView *view3;

+(AddEventSettingView *) createEventSettingView;
@end
