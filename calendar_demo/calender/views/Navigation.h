//
//  Navigation.h
//  calender
//
//  Created by xiangfang on 13-5-11.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Navigation : UIView

@property IBOutlet UIButton * leftBtn;
@property IBOutlet UIButton * rightBtn;

+(Navigation *) createNavigationView;

@end
