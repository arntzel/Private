

#import <UIKit/UIKit.h>
#import "Location.h"

@protocol AddLocationViewControllerDelegate <NSObject>

- (void)setLocation:(Location *)location;

@end

@interface AddLocationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISearchBar *locationSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *txtSearchTabView;
@property (weak, nonatomic) IBOutlet UITableView *nearBySearchTabView;

@property (weak, nonatomic) id<AddLocationViewControllerDelegate> delegate;

@end
