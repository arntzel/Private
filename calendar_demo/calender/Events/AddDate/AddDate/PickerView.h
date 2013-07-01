
#import <UIKit/UIKit.h>
@class PickerView;

@protocol PickerViewDelegate <NSObject>

- (void)selector:(PickerView *)valueSelector didSelectRowAtIndex:(NSInteger)index;

- (NSInteger)numberOfRowsInPicker:(PickerView *)picker;
- (UIView *)selector:(PickerView *)valueSelector viewForRowAtIndex:(NSInteger) index;
@end

@protocol PickerViewDataSource <NSObject>

@end



@interface PickerView : UIView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) id <PickerViewDelegate> delegate;

@property (nonatomic,assign) BOOL repeatEnable;

- (id)initWithFrame:(CGRect)frame Delegate:(id <PickerViewDelegate>)_delegate;
- (void)reloadData;

@end
