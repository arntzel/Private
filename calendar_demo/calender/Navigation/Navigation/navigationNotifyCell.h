#import <UIKit/UIKit.h>
#import "AttributedLabel.h"

@interface navigationNotifyCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *headerIcon;
@property (retain, nonatomic) IBOutlet AttributedLabel *NotifyDetailLabel;
@property (retain, nonatomic) IBOutlet UILabel *notifyDateLabel;

@end
