#import <UIKit/UIKit.h>
#import "EventTimePickerDefine.h"

@class CStartTimeView;
@protocol StartTimeViewDelegate <NSObject>

- (void)startTimeViewIsHiddening;
- (void)didTapdView:(UIView *)view;
- (void)startTimeViewIsShowing;

- (void)showEndTimePicker:(BOOL)show;
- (void)setEndEventTimePicker:(NSInteger)endTimeType;

- (void)startTimeView:(CStartTimeView *)picker changePickerType:(NSString *)datePickerType;
- (void)startTimeView:(CStartTimeView *)picker timeDidChanged:(NSDate *)changedTime;

@end

@interface CStartTimeView : UIView

@property(nonatomic,weak) id<StartTimeViewDelegate> delegate;

- (void)showStartPicker:(BOOL)animation;
- (void)HiddenStartPicker:(BOOL)animation;

- (BOOL)isTimePickerHidden;

- (void)setStartTime:(NSDate *)startTime StartType:(NSString *)startType;

@end
