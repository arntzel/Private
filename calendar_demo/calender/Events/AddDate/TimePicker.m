//
//  TimePicker.m
//  AddDate
//
//  Created by 张亚 on 13-7-2.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "TimePicker.h"
#import "LoopPickerView.h"
#import "PickerView.h"
#import "DeviceInfo.h"
#import "CustomSwitch.h"

@interface TimePicker()<PickerViewDelegate>
{
    LoopPickerView *hourPicker;
    LoopPickerView *minPicker;
    PickerView *AMPMPicker;
    
    CustomSwitch *startTimeTypeSwitch;
    
    NSInteger Hours;
    NSInteger Minutes;
    NSInteger Ampm;
    
    NSInteger startType;
    
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

- (void)setHours:(NSInteger)hours_ Minutes:(NSInteger)minutes_ Animation:(BOOL)animation
{
    Hours = hours_%12;
    Minutes = minutes_;
    Ampm = hours_/12;
    
    [hourPicker scrollToIndex:hours_%12 WithAnimation:animation];
    [minPicker scrollToIndex:minutes_ / 15 WithAnimation:animation];
    [AMPMPicker scrollToIndex:hours_/12 WithAnimation:animation];
}

- (void)setStartTimeType:(NSString *)startTimeType
{
    if([startTimeType isEqualToString:START_TYPEEXACTLYAT])
    {
        startType = 0;
        [startTimeTypeSwitch selectIndex:0];
    }
    else if([startTimeType isEqualToString:START_TYPEWITHIN])
    {
        startType = 1;
        [startTimeTypeSwitch selectIndex:1];
    }
    else if([startTimeType isEqualToString:START_TYPEAFTER])
    {
        startType = 2;
        [startTimeTypeSwitch selectIndex:2];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.5f]];
        
        Hours = 0;
        Minutes = 0;
        Ampm = 0;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, [DeviceInfo fullScreenHeight] - 57 - 161, self.bounds.size.width, 57 + 161)];
        [self addSubview:bgView];
        [bgView setBackgroundColor:[UIColor colorWithRed:227.0/255.0f green:227.0/255.0f blue:227.0/255.0f alpha:1.0f]];
        [bgView release];

        hourPicker = [[LoopPickerView alloc] initWithFrame:CGRectMake(0, [DeviceInfo fullScreenHeight] - 160, 106, 160)];
        [self addSubview:hourPicker];
        [hourPicker setDelegate:self];
        [hourPicker setUnitOffset:77];
        [hourPicker setUnitString:@""];
        [hourPicker reloadData];
        [hourPicker scrollToIndex:6 WithAnimation:NO];
        
        minPicker = [[LoopPickerView alloc] initWithFrame:CGRectMake(107, [DeviceInfo fullScreenHeight] - 160, 106, 160)];
        [self addSubview:minPicker];
        [minPicker setDelegate:self];
        [minPicker setUnitOffset:77];
        [minPicker setUnitString:@""];
        [minPicker reloadData];
        [minPicker scrollToIndex:30 WithAnimation:NO];
        
        AMPMPicker = [[PickerView alloc] initWithFrame:CGRectMake(214, [DeviceInfo fullScreenHeight] - 160, 106, 160)];
        [self addSubview:AMPMPicker];
        [AMPMPicker setDelegate:self];
        [AMPMPicker reloadData];
        [AMPMPicker scrollToIndex:0 WithAnimation:NO];
        
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
        return 4;
    }
    else
    {
        return 2;
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
        Hours = index;
    }
    else if(pickerView == minPicker)
    {
        Minutes = index * 15;
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

- (NSString *)stringOfRowsInPicker:(id<PickerViewProtocal>)picker AtIndex:(NSInteger)index
{
    if (picker == AMPMPicker) {
        if (index == 0) {
            return @"AM";
        }
        else if (index == 1)
        {
            return @"PM";
        }
        else
        {
            return @"";
        }
    }
    else
    {
        return @"";
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

-(void)sliderValueChanged:(CustomSwitch *) sender
{
    NSInteger index = sender.selectedIndex;
    LOG_D(@"%d",index);
    
    if (index == 0) {
        startType = 0;
        [self.delegate setStartTimeType:START_TYPEEXACTLYAT];
    }
    else if(index == 1)
    {
        startType = 1;
        [self.delegate setStartTimeType:START_TYPEWITHIN];
    }
    else if(index == 2)
    {
        startType = 2;
        [self.delegate setStartTimeType:START_TYPEAFTER];
    }
}

@end
