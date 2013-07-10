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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.5f]];
        
        hours = 0;
        minutes = 0;
        
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
    toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, [DeviceInfo fullScreenHeight] - 58, 320, 57)];
    [toolBar setBackgroundColor:[UIColor colorWithRed:245.0/255.0f green:245.0/255.0f blue:245.0/255.0f alpha:1.0f]];
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

-(void)sliderValueChanged:(CustomSwitch *) sender{
    NSLog(@"%d",sender.selectedIndex);
}
@end
