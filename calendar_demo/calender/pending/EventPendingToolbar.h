

#import <UIKit/UIKit.h>

@protocol EventPendingToolbarDelegate <NSObject>

-(void) onButtonSelected:(int)index;

@end

@interface EventPendingToolbar : UIView

@property IBOutlet UIButton * leftBtn;
@property IBOutlet UIButton * rightBtn;


-(IBAction) leftBtnSelected:(id)sender;

-(IBAction) rigthBtnSelected:(id)sender;



@property(nonatomic, assign) id<EventPendingToolbarDelegate> delegate;

+(EventPendingToolbar*) createView;

@end
