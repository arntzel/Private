//
//  DuringTimePicker.m
//  AddDate
//
//  Created by zyax86 on 13-7-2.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "DuringTimePicker.h"
#import "LoopPickerView.h"
#import "DeviceInfo.h"

@interface DuringTimePicker()<PickerViewDelegate>
{
    LoopPickerView *hourPicker;
    LoopPickerView *minPicker;
    
    UIView *toolBar;
    
    NSInteger hours;
    NSInteger minutes;
}
@end

@implementation DuringTimePicker
@synthesize delegate;

- (void)dealloc
{
    [hourPicker release];
    [minPicker release];
    [toolBar release];
    
    [super dealloc];
}

- (id)init
{
    return [self initWithFrame:[DeviceInfo fullScreenFrame]];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.5f]];
        
        hours = 0;
        minutes = 0;
        
        toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, [DeviceInfo fullScreenHeight] - 50, 320, 50)];
        [self addSubview:toolBar];
        [self initToolBar];
        
        hourPicker = [[LoopPickerView alloc] initWithFrame:CGRectMake(0, [DeviceInfo fullScreenHeight] - toolBar.frame.size.height - 161, 159, 160)];
        [self addSubview:hourPicker];
        [hourPicker setDelegate:self];
        [hourPicker setUnitString:@"hours"];
        [hourPicker reloadData];
        [hourPicker scrollToIndex:12 WithAnimation:NO];
        
        minPicker = [[LoopPickerView alloc] initWithFrame:CGRectMake(160, [DeviceInfo fullScreenHeight] - toolBar.frame.size.height - 161, 160, 160)];
        [self addSubview:minPicker];
        [minPicker setDelegate:self];
        [minPicker setUnitString:@"minutes"];
        [minPicker reloadData];
        [minPicker scrollToIndex:30 WithAnimation:NO];
    }
    return self;
}

- (void)initToolBar
{
    [toolBar setBackgroundColor:[UIColor colorWithRed:252/255.0f green:252/255.0f blue:252/255.0f alpha:1.0f]];
    UISwitch *allDaySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 40, 100)];
    [allDaySwitch setCenter:CGPointMake(toolBar.frame.size.width / 2 + 50, toolBar.frame.size.height / 2)];
    [toolBar addSubview:allDaySwitch];
    [allDaySwitch release];
}

- (NSInteger)numberOfRowsInPicker:(LoopPickerView *)pickerView {
    if (pickerView == hourPicker) {
        return 24;
    }
    else
    {
        return 60;
    }
}

- (void)Picker:(LoopPickerView *)pickerView didSelectRowAtIndex:(NSInteger)index {
    NSLog(@"Selected index %d",index);
    if (pickerView == hourPicker) {
        hours = index;
    }
    else if(pickerView == minPicker)
    {
        minutes = index;
    }
    if ([self.delegate respondsToSelector:@selector(setDurationHours:Minutes:)]) {
        [self.delegate setDurationHours:hours Minutes:minutes];
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}
@end
