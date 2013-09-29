//
//  EventDetailTimeView.h
//  detail
//
//  Created by zyax86 on 13-8-4.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@protocol EventDetailTimeViewDelegate <NSObject>

-(void) onEventDetailTimeViewFrameChanged;

@end

@interface EventDetailTimeView : UIView

@property(assign)  id<EventDetailTimeViewDelegate> delegate;

- (id)init;

-(void) updateView:(BOOL) isCreator andEvent:(Event *) event;

@end
