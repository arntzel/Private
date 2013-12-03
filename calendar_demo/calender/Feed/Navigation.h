

#import <UIKit/UIKit.h>

/*
 The Customer Navigation View, contain a left button , right button and a title lable
 */
@interface Navigation : UIView

@property IBOutlet UILabel * titleLable;
@property IBOutlet UIButton * leftBtn;
@property IBOutlet UIButton * rightBtn;
@property IBOutlet UILabel * unreadCount;
/*
 Create a default Navigation View
 Please set the title, left btn and right btn style after the view created.
 */
+(Navigation *) createNavigationView;

@end
