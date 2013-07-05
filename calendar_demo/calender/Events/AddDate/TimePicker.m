//
//  TimePicker.m
//  AddDate
//
//  Created by 张亚 on 13-7-2.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "TimePicker.h"
#import "LoopPickerView.h"
#import "DeviceInfo.h"

@interface TimePicker()<PickerViewDelegate>
{
    LoopPickerView *hourPicker;
    LoopPickerView *minPicker;
    LoopPickerView *AMPMPicker;
    
    UIView *toolBar;
}

@end

@implementation TimePicker

- (id)init
{
    return [self initWithFrame:[DeviceInfo fullScreenFrame]];
}

- (void)dealloc
{
    [hourPicker release];
    [minPicker release];
    [AMPMPicker release];
    
    [toolBar release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.5f]];

        hourPicker = [[LoopPickerView alloc] initWithFrame:CGRectMake(0, [DeviceInfo fullScreenHeight] - 160, 106, 160)];
        [self addSubview:hourPicker];
        [hourPicker setDelegate:self];
        [hourPicker setUnitString:@"hours"];
        [hourPicker reloadData];
        [hourPicker scrollToIndex:6 WithAnimation:NO];
        
        minPicker = [[LoopPickerView alloc] initWithFrame:CGRectMake(107, [DeviceInfo fullScreenHeight] - 160, 106, 160)];
        [self addSubview:minPicker];
        [minPicker setDelegate:self];
        [minPicker setUnitString:@"minutes"];
        [minPicker reloadData];
        [minPicker scrollToIndex:30 WithAnimation:NO];
        
        AMPMPicker = [[LoopPickerView alloc] initWithFrame:CGRectMake(214, [DeviceInfo fullScreenHeight] - 160, 106, 160)];
        [self addSubview:AMPMPicker];
        [AMPMPicker setDelegate:self];
        [AMPMPicker setUnitString:@""];
        [AMPMPicker reloadData];
        [AMPMPicker scrollToIndex:1 WithAnimation:NO];
        
        toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, [DeviceInfo fullScreenHeight] - 51 - 160, 320, 50)];
        [self addSubview:toolBar];
        [self initToolBar];
    }
    return self;
}

- (void)initToolBar
{
    [toolBar setBackgroundColor:[UIColor colorWithRed:252/255.0f green:252/255.0f blue:252/255.0f alpha:1.0f]];
    NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"exactly at",@"in an hour",@"time after", nil];
//    NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"exactly at",@"with in an hour",@"any time after", nil];
    UISegmentedControl *typeContrl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    [typeContrl setFrame:CGRectMake(0, 0, 320, 50)];
    [segmentedArray release];
    [typeContrl setCenter:CGPointMake(toolBar.frame.size.width / 2 , toolBar.frame.size.height / 2)];
    [toolBar addSubview:typeContrl];
    [typeContrl release];
    [typeContrl setSelectedSegmentIndex:0];
    
}

- (NSInteger)numberOfRowsInPicker:(LoopPickerView *)pickerView {
    if (pickerView == hourPicker) {
        return 12;
    }
    else if(pickerView == minPicker)
    {
        return 60;
    }
    else
    {
        return 2;
    }
}

- (void)Picker:(LoopPickerView *)pickerView didSelectRowAtIndex:(NSInteger)index {
    NSLog(@"Selected index %d",index);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

@end
