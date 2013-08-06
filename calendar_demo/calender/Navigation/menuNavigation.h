#import <UIKit/UIKit.h>

@protocol MenuNavigationDelegate <NSObject>

-(void) onMenuSelected:(int) menuIndex;

@end

@interface menuNavigation : UIViewController

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic, weak) id<MenuNavigationDelegate> delegate;

@end
