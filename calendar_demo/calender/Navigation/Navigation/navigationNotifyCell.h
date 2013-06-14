#import <UIKit/UIKit.h>
#import "AttributedLabel.h"
#import "Message.h"

@interface navigationNotifyCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *headerIcon;
@property (retain, nonatomic) IBOutlet AttributedLabel *NotifyDetailLabel;
@property (retain, nonatomic) IBOutlet UILabel *notifyDateLabel;


-(void) refreshView:(Message *) msg;

@end
