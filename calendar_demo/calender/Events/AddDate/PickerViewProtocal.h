
#import <Foundation/Foundation.h>

@protocol PickerViewProtocal <NSObject>

- (void)reloadData;
- (void)scrollToIndex:(NSInteger)index WithAnimation:(BOOL)animation;

@end


@protocol PickerViewDelegate <NSObject>

- (void)Picker:(id<PickerViewProtocal>)PickerView didSelectRowAtIndex:(NSInteger)index;
- (NSInteger)numberOfRowsInPicker:(id<PickerViewProtocal>)picker;

@optional
- (NSString *)stringOfRowsInPicker:(id<PickerViewProtocal>)picker AtIndex:(NSInteger)index;
- (NSInteger)integerOfRowsInPicker:(id<PickerViewProtocal>)picker AtIndex:(NSInteger)index;

@end
