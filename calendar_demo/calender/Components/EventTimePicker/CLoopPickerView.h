
#import <UIKit/UIKit.h>
#import "CPickerViewProtocal.h"

@interface CLoopPickerView : UIView <UITableViewDataSource,UITableViewDelegate,CPickerViewInterface>

@property (nonatomic,assign) id <CPickerViewProtocol> delegate;

- (id)initWithFrame:(CGRect)frame;
- (void)reloadData;
- (void)scrollToIndex:(NSInteger)index WithAnimation:(BOOL)animation;

- (void)setTextAlignment:(NSTextAlignment)textAlignment;
- (void)setTextHidden:(Boolean)hidden;

@end
