
#import <Foundation/Foundation.h>

@protocol CPickerViewInterface <NSObject>

- (void)reloadData;
- (void)scrollToIndex:(NSInteger)index WithAnimation:(BOOL)animation;

@end


@protocol CPickerViewProtocol <NSObject>

- (void)Picker:(id<CPickerViewInterface>)PickerView didSelectRowAtIndex:(NSInteger)index;
- (NSInteger)numberOfRowsInPicker:(id<CPickerViewInterface>)picker;

@optional
- (NSString *)stringOfRowsInPicker:(id<CPickerViewInterface>)picker AtIndex:(NSInteger)index;
- (NSInteger)integerOfRowsInPicker:(id<CPickerViewInterface>)picker AtIndex:(NSInteger)index;

@end
