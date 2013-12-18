

#import <UIKit/UIKit.h>


typedef enum
{
    FEED_PENDING,  //add add invite
    ACCOUNT_SETTING  //detail add invite
} ViewMode;
/*
 The Customer Navigation View, contain a left button , right button and a title lable
 */
@interface Navigation : UIView

@property (strong) IBOutlet UILabel * titleLable;
@property (strong) IBOutlet UIButton * leftBtn;
@property (strong) IBOutlet UIButton * rightBtn;
@property (strong) IBOutlet UISegmentedControl *calPendingSegment;
@property (strong) IBOutlet UILabel * unreadCount;
/*
 Create a default Navigation View
 Please set the title, left btn and right btn style after the view created.
 */
+(Navigation *) createNavigationView;

-(void)setUpMainNavigationButtons:(ViewMode)mode;

@end
