//
//  TimePicker.m
//  AddDate
//
//  Created by 张亚 on 13-7-2.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "TimePicker.h"
#import "PickerView.h"

@interface TimePicker()<PickerViewDataSource,PickerViewDelegate>
{
    PickerView *hourPicker;
    PickerView *minPicker;
    PickerView *AMPMPicker;
}

@end

@implementation TimePicker

- (id)init
{
    return [self initWithFrame:CGRectMake(0, 0, 320, 160)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        hourPicker = [[PickerView alloc] initWithFrame:CGRectMake(0, 0, 106, 160)];
        [self addSubview:hourPicker];
        [hourPicker setDelegate:self];
        [hourPicker setRepeatEnable:YES];
        [hourPicker setUnitString:@"hours"];
        [hourPicker reloadData];
        [hourPicker scrollToIndex:6 WithAnimation:NO];
        
        minPicker = [[PickerView alloc] initWithFrame:CGRectMake(107, 0, 106, 160)];
        [self addSubview:minPicker];
        [minPicker setDelegate:self];
        [minPicker setRepeatEnable:YES];
        [minPicker setUnitString:@"minutes"];
        [minPicker reloadData];
        [minPicker scrollToIndex:30 WithAnimation:NO];
        
        AMPMPicker = [[PickerView alloc] initWithFrame:CGRectMake(214, 0, 106, 160)];
        [self addSubview:AMPMPicker];
        [AMPMPicker setDelegate:self];
        [AMPMPicker setRepeatEnable:NO];
        [AMPMPicker setUnitString:@""];
        [AMPMPicker reloadData];
        [AMPMPicker scrollToIndex:1 WithAnimation:NO];
    }
    return self;
}

- (NSInteger)numberOfRowsInPicker:(PickerView *)pickerView {
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

- (void)selector:(PickerView *)pickerView didSelectRowAtIndex:(NSInteger)index {
    NSLog(@"Selected index %d",index);
}

@end
