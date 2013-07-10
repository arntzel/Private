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
#import "CustomSwitch.h"

@interface TimePicker()<PickerViewDelegate>
{
    LoopPickerView *hourPicker;
    LoopPickerView *minPicker;
    LoopPickerView *AMPMPicker;
    
    CustomSwitch *startTimeTypeSwitch;
    
    NSInteger Hours;
    NSInteger Minutes;
    NSInteger Ampm;
    
}

@end

@implementation TimePicker
@synthesize delegate;

- (id)init
{
    return [self initWithFrame:[DeviceInfo fullScreenFrame]];
}

- (void)dealloc
{
    hourPicker.delegate = nil;
    [hourPicker release];
    minPicker.delegate = nil;
    [minPicker release];
    AMPMPicker.delegate = nil;
    [AMPMPicker release];
    
    [startTimeTypeSwitch removeTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [startTimeTypeSwitch release];

    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.5f]];
        
        Hours = 0;
        Minutes = 0;
        Ampm = 0;

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
        
        [self initToolBar];
    }
    return self;
}

- (void)initToolBar
{
    UIView *startTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, [DeviceInfo fullScreenHeight] - 58 - 160, 320, 57)];
    [startTypeView setBackgroundColor:[UIColor colorWithRed:245.0/255.0f green:245.0/255.0f blue:245.0/255.0f alpha:1.0f]];
    [self addSubview:startTypeView];
    
    startTimeTypeSwitch = [[CustomSwitch alloc] initWithFrame:CGRectMake(5, 5, 310, 42) segmentCount:3];
    [startTimeTypeSwitch setSegTitle:@"exactly at" AtIndex:0];
    [startTimeTypeSwitch setSegTitle:@"within an hour" AtIndex:1];
    [startTimeTypeSwitch setSegTitle:@"anytime after" AtIndex:2];
    [startTypeView addSubview:startTimeTypeSwitch];
    [startTimeTypeSwitch addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [startTypeView release];
    
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
    if (pickerView == hourPicker) {
        Hours = index;
    }
    else if(pickerView == minPicker)
    {
        Minutes = index;
    }
    else
    {
        Ampm = index;
    }
    
    if ([self.delegate respondsToSelector:@selector(setStartTimeHours:Minutes:AMPM:)])
    {
        [self.delegate setStartTimeHours:Hours Minutes:Minutes AMPM:Ampm];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

-(void)sliderValueChanged:(CustomSwitch *) sender
{
    NSInteger index = sender.selectedIndex;
    NSLog(@"%d",index);
    
    if (index == 0) {
        [self.delegate setStartTimeType:START_TYPEEXACTLYAT];
    }
    else if(index == 1)
    {
        [self.delegate setStartTimeType:START_TYPEWITHIN];
    }
    else if(index == 2)
    {
        [self.delegate setStartTimeType:START_TYPEAFTER];
    }
}

@end
