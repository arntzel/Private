//
//  EventDetailPlaceView.h
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailPlaceView : UIView
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UIImageView *mapView;

+(EventDetailPlaceView *) creatView;

@end