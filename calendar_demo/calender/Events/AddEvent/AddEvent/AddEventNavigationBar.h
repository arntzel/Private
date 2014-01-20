#import <UIKit/UIKit.h>

@protocol AddEventNavigationBarDelegate <NSObject>

- (void)leftBtnPress:(id)sender;
- (void)rightBtnPress:(id)sender;

@end

@interface AddEventNavigationBar : UIView
@property(nonatomic,assign) id<AddEventNavigationBarDelegate> delegate;

@property (retain, nonatomic) IBOutlet UIButton *leftBtn;
@property (retain, nonatomic) IBOutlet UIButton *rightbtn;

- (IBAction)leftBtnClick:(id)sender;
- (IBAction)rightBtnClick:(id)sender;
-(void) setRightBtnEnable:(BOOL)enable;

+(AddEventNavigationBar *) creatView;
@end
