
#import <UIKit/UIKit.h>
#import "PickerViewProtocal.h"

@interface LoopPickerView : UIView <UITableViewDataSource,UITableViewDelegate,PickerViewProtocal>

@property (nonatomic,assign) id <PickerViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;
- (void)reloadData;
- (void)scrollToIndex:(NSInteger)index WithAnimation:(BOOL)animation;

- (void)setUnitString:(NSString *)UnitString;
- (void)setUnitOffset:(CGFloat)offset;

@end
