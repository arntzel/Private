//
//  DuringTimePicker.m
//  AddDate
//
//  Created by zyax86 on 13-7-2.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "DuringTimePicker.h"
#import "PickerView.h"
@interface DuringTimePicker()<PickerViewDataSource,PickerViewDelegate>
{
    PickerView *hourPicker;
    PickerView *minPicker;
}
@end

@implementation DuringTimePicker

- (void)dealloc
{
    [hourPicker release];
    [minPicker release];
    
    [super dealloc];
}

- (id)init
{
    return [self initWithFrame:CGRectMake(0, 250, 320, 160)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        hourPicker = [[PickerView alloc] initWithFrame:CGRectMake(0, 0, 159, 160)];
        [self addSubview:hourPicker];
        [hourPicker setDelegate:self];
        [hourPicker setRepeatEnable:YES];
        [hourPicker setUnitString:@"hours"];
        [hourPicker reloadData];
        [hourPicker scrollToIndex:12 WithAnimation:NO];
        
        minPicker = [[PickerView alloc] initWithFrame:CGRectMake(160, 0, 160, 160)];
        [self addSubview:minPicker];
        [minPicker setDelegate:self];
        [minPicker setRepeatEnable:YES];
        [minPicker setUnitString:@"minutes"];
        [minPicker reloadData];
        [minPicker scrollToIndex:30 WithAnimation:NO];
    }
    return self;
}

- (NSInteger)numberOfRowsInPicker:(PickerView *)pickerView {
    if (pickerView == hourPicker) {
        return 24;
    }
    else
    {
        return 60;
    }
}

- (void)selector:(PickerView *)pickerView didSelectRowAtIndex:(NSInteger)index {
    NSLog(@"Selected index %d",index);
}


@end
