

#import <UIKit/UIKit.h>
#import "Location.h"
#import "BaseUIViewController.h"

@protocol AddLocationViewControllerDelegate <NSObject>

- (void)setLocation:(Location *)location;

@end

@interface AddLocationViewController : BaseUIViewController

@property (retain, nonatomic) IBOutlet UITableView *txtSearchTabView;

@property(retain, nonatomic) Location * location;


@property (weak, nonatomic) id<AddLocationViewControllerDelegate> delegate;


@end
