//
//  EventDetailPlaceView.h
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@interface EventDetailPlaceView : UIView
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UILabel * locationNameLabel;


-(void) setLocation:(Location *) location;

- (BOOL)haveLocation;
+(EventDetailPlaceView *) creatView;
- (void)addMask:(BOOL)canChangeLocation;

@end
