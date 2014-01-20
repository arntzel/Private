#import <UIKit/UIKit.h>
#import "CPickerViewProtocal.h"


@interface CPickerView : UIView<CPickerViewInterface>

@property (nonatomic,weak) id <CPickerViewProtocol> delegate;

- (id)initWithFrame:(CGRect)frame;
- (void)scrollToIndex:(NSInteger)index WithAnimation:(BOOL)animation;
- (void)reloadData;

- (void)setTextAlignment:(NSTextAlignment)textAlignment;
- (void)setTextHidden:(Boolean)hidden;
@end
