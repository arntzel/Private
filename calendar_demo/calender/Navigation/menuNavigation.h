#import <UIKit/UIKit.h>

@interface menuNavigation : UIViewController

@property(nonatomic,strong) UITableView *tableView;

- (UIViewController*)localAlbumController;

- (UIViewController*)cloudAlbumController;

@end
