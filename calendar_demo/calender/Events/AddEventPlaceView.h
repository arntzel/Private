//
//  AddEventPlaceView.h
//  calender
//
//  Created by fang xiang on 13-7-11.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@interface AddEventPlaceView : UIView

@property(retain, nonatomic) IBOutlet UILabel * label;
@property(retain, nonatomic) IBOutlet UIButton * btnPick;

@property(retain, nonatomic) IBOutlet UIView * mapView;


-(void) setLocation:(Location*) location;

@end
