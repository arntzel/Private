//
//  TimePicker.m
//  AddDate
//
//  Created by 张亚 on 13-7-2.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "TimePicker.h"
#import "LoopPickerView.h"

@interface TimePicker()<PickerViewDelegate>
{
    LoopPickerView *hourPicker;
    LoopPickerView *minPicker;
    LoopPickerView *AMPMPicker;
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
        hourPicker = [[LoopPickerView alloc] initWithFrame:CGRectMake(0, 0, 106, 160)];
        [self addSubview:hourPicker];
        [hourPicker setDelegate:self];
        [hourPicker setUnitString:@"hours"];
        [hourPicker reloadData];
        [hourPicker scrollToIndex:6 WithAnimation:NO];
        
        minPicker = [[LoopPickerView alloc] initWithFrame:CGRectMake(107, 0, 106, 160)];
        [self addSubview:minPicker];
        [minPicker setDelegate:self];
        [minPicker setUnitString:@"minutes"];
        [minPicker reloadData];
        [minPicker scrollToIndex:30 WithAnimation:NO];
        
        AMPMPicker = [[LoopPickerView alloc] initWithFrame:CGRectMake(214, 0, 106, 160)];
        [self addSubview:AMPMPicker];
        [AMPMPicker setDelegate:self];
        [AMPMPicker setUnitString:@""];
        [AMPMPicker reloadData];
        [AMPMPicker scrollToIndex:1 WithAnimation:NO];
    }
    return self;
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

@end
