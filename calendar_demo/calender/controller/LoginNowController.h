
#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"

@interface LoginNowController : BaseUIViewController

@property IBOutlet UITextField * tvUsername;
@property IBOutlet UITextField * tvPassword;
@property IBOutlet UIButton * btnLogin;

@property IBOutlet UIBarButtonItem * btnBack;

@property IBOutlet UIActivityIndicatorView * progress;


-(IBAction) back:(id)sender;

-(IBAction) login:(id)sender;

@end
