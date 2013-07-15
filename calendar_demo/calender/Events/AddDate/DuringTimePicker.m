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
#import "CustomSwitch.h"

@interface DuringTimePicker()<PickerViewDelegate>
{
    LoopPickerView *hourPicker;
    LoopPickerView *minPicker;
    CustomSwitch *isAllDaySwitch;
    
    UIView *toolBar;
    
    NSInteger hours;
    NSInteger minutes;
}
@end

@implementation DuringTimePicker
@synthesize delegate;

- (void)dealloc
{
    hourPicker.delegate = nil;
    [hourPicker release];
    minPicker.delegate = nil;
    [minPicker release];
    
    [isAllDaySwitch removeTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [isAllDaySwitch release];
    
    [toolBar release];
    
    [super dealloc];
}

- (id)init
{
    return [self initWithFrame:[DeviceInfo fullScreenFrame]];
}

- (void)setHours:(NSInteger)hours_ Minutes:(NSInteger)minutes_ Animation:(BOOL)animation
{
    hours = hours_;
    minutes = minutes_;
    [hourPicker scrollToIndex:hours_ WithAnimation:animation];
    [minPicker scrollToIndex:minutes_ / 15 WithAnimation:animation];
}

- (void)setisAllDate:(BOOL)isAllDay
{
    if(isAllDay)
    {
        [isAllDaySwitch selectIndex:0];
    }
    else
    {
        [isAllDaySwitch selectIndex:1];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.5f]];
        
        hours = 0;
        minutes = 0;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, [DeviceInfo fullScreenHeight] - 57 - 161, self.bounds.size.width, 57 + 161)];
        [self addSubview:bgView];
        [bgView setBackgroundColor:[UIColor colorWithRed:227.0/255.0f green:227.0/255.0f blue:227.0/255.0f alpha:1.0f]];
        [bgView release];
        
        [self initToolBar];
        
        hourPicker = [[LoopPickerView alloc] initWithFrame:CGRectMake(0, [DeviceInfo fullScreenHeight] - toolBar.frame.size.height - 161, 159, 160)];
        [self addSubview:hourPicker];
        [hourPicker setDelegate:self];
        [hourPicker setUnitOffset:80];
        [hourPicker setUnitString:@"hours"];
        [hourPicker reloadData];
        [hourPicker scrollToIndex:12 WithAnimation:NO];
        
        minPicker = [[LoopPickerView alloc] initWithFrame:CGRectMake(160, [DeviceInfo fullScreenHeight] - toolBar.frame.size.height - 161, 160, 160)];
        [self addSubview:minPicker];
        [minPicker setDelegate:self];
        [minPicker setUnitOffset:70];
        [minPicker setUnitString:@"minutes"];
        [minPicker reloadData];
        [minPicker scrollToIndex:30 WithAnimation:NO];
    }
    return self;
}

- (void)initToolBar
{
    toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, [DeviceInfo fullScreenHeight] - 57, 320, 57)];
    [toolBar setBackgroundColor:[UIColor colorWithRed:252/255.0f green:252/255.0f blue:252/255.0f alpha:1.0f]];
    [self addSubview:toolBar];
    
    
    CGRect labelFrame = toolBar.bounds;
    labelFrame.origin.x = 15;
    labelFrame.size.width = 200;
    UILabel *isAllDayLabel = [[UILabel alloc] initWithFrame:labelFrame];
    [isAllDayLabel setBackgroundColor:[UIColor clearColor]];
    [isAllDayLabel setTextAlignment:NSTextAlignmentLeft];
    [isAllDayLabel setTextColor:[UIColor colorWithRed:116.0f/255.0f green:116.0f/255.0f blue:116.0f/255.0f alpha:1.0f]];
    [isAllDayLabel setFont:[UIFont systemFontOfSize:16]];
    isAllDayLabel.text = @"All Day?";
    [toolBar addSubview:isAllDayLabel];
    
    isAllDaySwitch = [[CustomSwitch alloc] initWithFrame:CGRectMake(320 - 10 - 121, 10, 121, 40) segmentCount:2];
    [isAllDaySwitch setSegTitle:@"Yes" AtIndex:0];
    [isAllDaySwitch setSegTitle:@"No" AtIndex:1];
    [toolBar addSubview:isAllDaySwitch];
    [isAllDaySwitch addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (NSInteger)numberOfRowsInPicker:(LoopPickerView *)pickerView {
    if (pickerView == hourPicker) {
        return 24;
    }
    else
    {
        return 4;
    }
}

- (NSInteger)integerOfRowsInPicker:(LoopPickerView *)pickerView AtIndex:(NSInteger)index
{
    if (pickerView == hourPicker) {
        return index;
    }
    else if(pickerView == minPicker)
    {
        return index * 15;
    }
    else
    {
        return 0;
    }
}

- (void)Picker:(LoopPickerView *)pickerView didSelectRowAtIndex:(NSInteger)index {
    LOG_D(@"Selected index %d",index);
    if (pickerView == hourPicker) {
        hours = index;
    }
    else if(pickerView == minPicker)
    {
        minutes = index * 15;
    }
    if ([self.delegate respondsToSelector:@selector(setDurationHours:Minutes:)]) {
        [self.delegate setDurationHours:hours Minutes:minutes];
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

-(void)sliderValueChanged:(CustomSwitch *) sender{
    NSInteger index = sender.selectedIndex;
    LOG_D(@"%d",index);
    
    if (index == 0) {
        [self.delegate setDurationAllDay:YES];
    }
    else if(index == 1)
    {
        [self.delegate setDurationAllDay:NO];
    }
}
@end
