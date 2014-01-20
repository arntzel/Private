#import <UIKit/UIKit.h>

@class CEndTimeTitle;

@protocol EndTimeTitleDelegate <NSObject>

- (void)didTapdView:(UIView *)view;

@end

@interface CEndTimeTitle : UIView

- (void)setEndTimeMode;
- (void)setDuringTimeMode;

- (void)setTime:(NSString *)timeString;

@property(nonatomic,weak) id<EndTimeTitleDelegate> delegate;

@end
