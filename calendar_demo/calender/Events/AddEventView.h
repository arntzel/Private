
#import <UIKit/UIKit.h>

@interface AddEventView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *viewEventPhoto;

@property (weak, nonatomic) IBOutlet UITextField *txtAddEventTitle;


@property (weak, nonatomic) IBOutlet UIButton *btnAddEventPhoto;
@property (weak, nonatomic) IBOutlet UIButton *btnInvitePeople;
@property (weak, nonatomic) IBOutlet UIButton *btnAddLocation;
@property (weak, nonatomic) IBOutlet UIButton *btnAddDate;


- (void)initAppearenceAfterLoad;

@end
