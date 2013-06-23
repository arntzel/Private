
#import <UIKit/UIKit.h>
@class CustomPickerView;

@protocol CustomPickerViewDelegate <NSObject>

- (void)selector:(CustomPickerView *)valueSelector didSelectRowAtIndex:(NSInteger)index;

- (NSInteger)numberOfRowsInSelector:(CustomPickerView *)valueSelector;
- (UIView *)selector:(CustomPickerView *)valueSelector viewForRowAtIndex:(NSInteger) index;
@end

@protocol CustomPickerViewDataSource <NSObject>

@end



@interface CustomPickerView : UIView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) id <CustomPickerViewDelegate> delegate;

@property (nonatomic,assign) BOOL debugEnabled;

- (id)initWithFrame:(CGRect)frame Delegate:(id <CustomPickerViewDelegate>)_delegate;
- (void)reloadData;

@end
