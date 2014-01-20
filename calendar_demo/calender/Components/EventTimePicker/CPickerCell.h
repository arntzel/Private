#import <UIKit/UIKit.h>
#import "EventTimePickerDefine.h"


@interface CPickerCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *label;
- (void)initUI;

- (void)setTextAlignment:(NSTextAlignment)textAlignment;

@end
