#import "DDMenuController.h"
#import "CoreDataModel.h"
#import "FeedViewController.h"

@interface MainViewController : DDMenuController <PopDelegate>

-(void)onBtnMenuClick;
-(void)onBtnCalendarClick;

-(void)refreshViews;

@property (strong, nonatomic) FeedViewController *feedViewCtr;

@end
