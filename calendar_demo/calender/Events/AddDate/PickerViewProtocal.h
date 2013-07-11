//
//  PickerViewProtocal.h
//  AddDate
//
//  Created by 张亚 on 13-7-4.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PickerViewProtocal <NSObject>

@property (nonatomic,assign) NSString *UnitString;

- (id)initWithFrame:(CGRect)frame;
- (void)reloadData;
- (void)scrollToIndex:(NSInteger)index WithAnimation:(BOOL)animation;

@end


@protocol PickerViewDelegate <NSObject>

- (void)Picker:(id<PickerViewProtocal>)PickerView didSelectRowAtIndex:(NSInteger)index;
- (NSInteger)numberOfRowsInPicker:(id<PickerViewProtocal>)picker;

@optional
- (NSString *)stringOfRowsInPicker:(id<PickerViewProtocal>)picker AtIndex:(NSInteger)index;

@end
