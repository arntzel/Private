

#import <UIKit/UIKit.h>

@interface LoginView : UIView


+(LoginView *) createView;

@property IBOutlet UIButton * signupGoogle;
@property IBOutlet UIButton * signupFacebook;
@property IBOutlet UIButton * signupEmail;

@property IBOutlet UILabel * loginnow;

@end
