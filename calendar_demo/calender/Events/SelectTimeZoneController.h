
#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"


@protocol SelectTimeZoneControllerDelegate <NSObject>

-(void) onSelectedTimezone:(NSString *) timezone;

@end

@interface SelectTimeZoneController : BaseUIViewController

@property(retain, nonatomic) IBOutlet UITableView * tableView;

@property(assign, nonatomic) id<SelectTimeZoneControllerDelegate> delegate;

@end
