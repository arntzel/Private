//
//  EventDetailTimeView.h
//  detail
//
//  Created by zyax86 on 13-8-4.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventTime.h"

@interface EventDetailTimeView : UIView

- (id)init;

-(void) updateView:(BOOL) isCreator andEventTimes:(NSArray *) times;

@end
