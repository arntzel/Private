

#import <UIKit/UIKit.h>
#import "Location.h"
#import "BaseUIViewController.h"

@protocol AddLocationViewControllerDelegate <NSObject>

- (void)setLocation:(Location *)location;

@end

@interface AddLocationViewController : BaseUIViewController
@property (weak, nonatomic) IBOutlet UISearchBar *locationSearchBar;
@property (weak, nonatomic) IBOutlet UITextField *locationInputField;
@property (weak, nonatomic) IBOutlet UITableView *txtSearchTabView;
@property (weak, nonatomic) IBOutlet UITableView *nearBySearchTabView;

@property (weak, nonatomic) id<AddLocationViewControllerDelegate> delegate;

@property(retain, nonatomic) Location * location;

@end
