#import <UIKit/UIKit.h>
#import "ProposeStart.h"

@class CEventTimePicker;
@protocol CEventTimePickerDelegate <NSObject>

- (void)EventTimePickerNeedLayout:(CEventTimePicker*)picker;

- (void)eventTimePickerDelete:(CEventTimePicker*)picker;

@end

@interface CEventTimePicker : UIView

@property(nonatomic,weak) id<CEventTimePickerDelegate> delegate;

- (void)getFocus;
- (void)loseFocus;

- (void)setTime:(ProposeStart *)time_;

- (ProposeStart *)getTime;
+ (NSString *)getStartTypeFromePropseType:(ProposeStart *)startTime;

@end
