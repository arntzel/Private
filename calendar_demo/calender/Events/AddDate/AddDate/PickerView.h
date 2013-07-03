//
//  PickerView.h
//  AddDate
//
//  Created by zyax86 on 13-7-3.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PickerView;

@protocol PickerViewDelegate <NSObject>

- (void)selector:(PickerView *)PickerView didSelectRowAtIndex:(NSInteger)index;
- (NSInteger)numberOfRowsInPicker:(PickerView *)picker;

- (CGFloat)heightPerRowInPicker:(PickerView *)picker;

@end

@protocol PickerViewDataSource <NSObject>

@end

@interface PickerView : UIView
@property (nonatomic,assign) id <PickerViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;
- (void)scrollToIndex:(NSInteger)index WithAnimation:(BOOL)animation;
- (void)reloadData;
@end
