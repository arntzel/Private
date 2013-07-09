
#import <UIKit/UIKit.h>
#import "EventDate.h"

@protocol TimePickerDelegate <NSObject>

- (void)setStartTimeType:(NSString *)startDateType;
- (void)setStartTimeHours:(NSInteger)hours Minutes:(NSInteger)minutes AMPM:(NSInteger)ampm;

@end

@interface TimePicker : UIView

@property(nonatomic,assign) id<TimePickerDelegate> delegate;

- (id)init;

@end
