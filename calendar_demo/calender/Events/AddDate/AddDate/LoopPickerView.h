
#import <UIKit/UIKit.h>
@class LoopPickerView;

@protocol LoopPickerViewDelegate <NSObject>

- (void)selector:(LoopPickerView *)PickerView didSelectRowAtIndex:(NSInteger)index;
- (NSInteger)numberOfRowsInPicker:(LoopPickerView *)picker;

@end

@protocol PickerViewDataSource <NSObject>

@end



@interface LoopPickerView : UIView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) id <LoopPickerViewDelegate> delegate;
@property (nonatomic,assign) BOOL repeatEnable;
@property (nonatomic,assign) NSString *UnitString;

- (id)initWithFrame:(CGRect)frame;
- (void)reloadData;
- (void)scrollToIndex:(NSInteger)index WithAnimation:(BOOL)animation;

@end
