//
//  EventFilterViewCell.m
//  Calvin
//
//  Created by fangxiang on 13-11-3.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "EventFilterViewCell.h"

#import "ViewUtils.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>


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
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventFilterViewCell" owner:self options:nil];
    EventFilterViewCell * view = (EventFilterViewCell*)[nibView objectAtIndex:0];
    
    view.btnSelect.selected = YES;
    
    view.colorDot.layer.cornerRadius = view.colorDot.frame.size.width/2;
    view.colorDot.layer.masksToBounds = YES;
    view.colorDot.backgroundColor = [ViewUtils getUIColor:[ViewUtils getEventTypeColor:eventType]];
    view.colorDot.image = nil;
    view.labelEventTypeName.text = [ViewUtils getEventTypeName:eventType];
    
    return view;
}
@end
