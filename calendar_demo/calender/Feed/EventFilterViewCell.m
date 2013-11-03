//
//  EventFilterViewCell.m
//  Calvin
//
//  Created by fangxiang on 13-11-3.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "EventFilterViewCell.h"

#import "ViewUtils.h"

@implementation EventFilterViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(EventFilterViewCell *) createView:(int) eventType
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventFilterView" owner:self options:nil];
    EventFilterViewCell * view = (EventFilterViewCell*)[nibView objectAtIndex:0];
    
    view.btnSelect.selected = YES;
    view.colorDot.backgroundColor = [ViewUtils getUIColor:[ViewUtils getEventTypeColor:eventType]];
    view.labelEventTypeName.text = [ViewUtils getEventTypeName:eventType];
    
    return view;
}
@end
