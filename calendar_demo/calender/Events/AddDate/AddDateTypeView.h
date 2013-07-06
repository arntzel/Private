#import <UIKit/UIKit.h>



@interface AddDateTypeView : UIView
@property (weak, nonatomic) IBOutlet UIButton *btnChooseTime;
@property (weak, nonatomic) IBOutlet UIButton *btnChooseDuration;

+(AddDateTypeView *) createView;
@end
