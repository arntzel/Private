
#import <UIKit/UIKit.h>
#import "ProposeStart.h"

@protocol TimePickerDelegate <NSObject>

- (void)setStartTimeType:(NSString *)startDateType;
- (void)setStartTimeHours:(NSInteger)hours Minutes:(NSInteger)minutes AMPM:(NSInteger)ampm;

@end

@interface TimePicker : UIView

@property(nonatomic,assign) id<TimePickerDelegate> delegate;

- (id)init;

- (void)setHours:(NSInteger)hours_ Minutes:(NSInteger)minutes_ Animation:(BOOL)animation;

- (void)setStartTimeType:(NSString *)startTimeType;

@end
