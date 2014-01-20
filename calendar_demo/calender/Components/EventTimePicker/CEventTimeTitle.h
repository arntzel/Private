#import <UIKit/UIKit.h>
#import "ProposeStart.h"

@class CEventTimeTitle;

@protocol EventTimeTitleDelegate <NSObject>

- (void)didTapdView:(UIView *)view;

-(void) didDeleteTime:(UIView *)view;

@end


@interface CEventTimeTitle : UIView

@property(nonatomic,weak) id<EventTimeTitleDelegate> delegate;

- (void)setTime:(ProposeStart *)startTime;

@end
