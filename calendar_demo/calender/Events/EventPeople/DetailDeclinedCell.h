
#import <UIKit/UIKit.h>

@interface DetailDeclinedCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView * peopleHeader;
@property (retain, nonatomic) IBOutlet UILabel * peopleName;
@property (weak, nonatomic) IBOutlet UILabel *declinedTime;

@end
