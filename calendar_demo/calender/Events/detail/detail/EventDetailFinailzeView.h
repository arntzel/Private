//
//  EventDetailFinailzeView.h
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailFinailzeView : UIView
@property (retain, nonatomic) IBOutlet UIView *finailzeView;
@property (retain, nonatomic) IBOutlet UIView *removeView;

+(EventDetailFinailzeView *) creatView;
@end
