
#import <UIKit/UIKit.h>

@interface RegisterNewUserViewController : UIViewController

@property IBOutlet UITextField * tfUsername;
@property IBOutlet UITextField * tfEmail;
@property IBOutlet UITextField * tfPassword;
@property IBOutlet UIActivityIndicatorView * indicator;

@property IBOutlet UIButton * btnSignup;


-(IBAction) cancel:(id)sender;

-(IBAction) signup:(id)sender;

@end
