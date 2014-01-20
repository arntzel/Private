#import <UIKit/UIKit.h>

@protocol AddEventAddTitleBarDelegate <NSObject>

- (void)leftNavBtnClick;
- (void)rightNavBtnClick;

@end

@interface AddEventAddTitleBar : UIImageView

@property(nonatomic, assign) id<AddEventAddTitleBarDelegate> delegate;

- (void)setTitle:(NSString *)title;
- (void)setLeftBtnText:(NSString *)text;
- (void)setRightBtnText:(NSString *)text;

- (void) setRightBtnHidden:(BOOL) hidden;
- (void) setTitleHidden:(BOOL) hidden;

-(void) setRightBtnEnable:(BOOL) enable;

@end
