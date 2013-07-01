
#import <UIKit/UIKit.h>
@class PickerView;

@protocol PickerViewDelegate <NSObject>

- (void)selector:(PickerView *)valueSelector didSelectRowAtIndex:(NSInteger)index;
- (NSInteger)numberOfRowsInPicker:(PickerView *)picker;

@end

@protocol PickerViewDataSource <NSObject>

@end



@interface PickerView : UIView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) id <PickerViewDelegate> delegate;
@property (nonatomic,assign) BOOL repeatEnable;
@property (nonatomic,assign) NSString *UnitString;

- (id)initWithFrame:(CGRect)frame;
- (void)reloadData;
- (void)scrollToIndex:(NSInteger)index WithAnimation:(BOOL)animation;

@end
