
#import <UIKit/UIKit.h>

@protocol SelectTimeZoneControllerDelegate <NSObject>

-(void) onSelectedTimezone:(NSString *) timezone;

@end

@interface SelectTimeZoneController : UIViewController

@property(retain, nonatomic) IBOutlet UITableView * tableView;

@property(assign, nonatomic) id<SelectTimeZoneControllerDelegate> delegate;

@end
