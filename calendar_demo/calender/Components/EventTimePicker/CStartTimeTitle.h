#import <UIKit/UIKit.h>

@class CStartTimeTitle;

@protocol StartTimeTitleDelegate <NSObject>

- (void)didTapdView:(UIView *)view;

@end


@interface CStartTimeTitle : UIView
@property(nonatomic,weak) id<StartTimeTitleDelegate> delegate;

- (void)setTime:(NSString *)timeString;

@end
