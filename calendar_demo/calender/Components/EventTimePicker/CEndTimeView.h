#import <UIKit/UIKit.h>

@class CEndTimeView;
@protocol EndTimeViewDelegate <NSObject>

- (void)EndTimeViewIsHiddening;
- (void)didTapdView:(UIView *)view;
- (void)EndTimeViewIsShowing;

- (void)endTimeView:(CEndTimeView *)picker duringDidChanged:(NSInteger)duringMinite_;
- (void)endTimeView:(CEndTimeView *)picker timeDidChanged:(NSDate *)endDate_;
@end

@interface CEndTimeView : UIView

@property(nonatomic,weak) id<EndTimeViewDelegate> delegate;
- (BOOL)isTimePickerHidden;

- (void)showEndPicker:(BOOL)animation;
- (void)HiddenEndPicker:(BOOL)animation;

- (void)setMode:(NSInteger)mode;
- (void)setEndTime:(NSDate *)endTime During:(NSInteger)during_;

@end
