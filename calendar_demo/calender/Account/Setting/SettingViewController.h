

#import <UIKit/UIKit.h>
#import "SettingsBaseViewController.h"

@interface SettingViewController : SettingsBaseViewController 

@property (nonatomic, copy) void (^updataLeftNavBlock)(void);
@property (nonatomic, assign) BOOL nameChanged;
@property(weak) id<BaseMenuViewControllerDelegate> delegate;

-(IBAction) logout:(id)sender;
- (void)updataUserProfile:(NSString *)avatar_url;
- (void)dismissKeyBoard:(id)sender;
@end
