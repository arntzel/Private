
#import <Foundation/Foundation.h>

@class CDuringTimePicker;

@protocol DuringTimePickerDelegate <NSObject>

- (void)DuringTimePicker:(CDuringTimePicker *)picker didChooseMinites:(NSInteger)minites;

@end

@interface CDuringTimePicker : UIView

@property(nonatomic, weak) id<DuringTimePickerDelegate> delegate;

- (NSInteger)getCurrentDuringMinites;
+ (NSString *)getFormatTimeForMinites:(NSInteger)minites_;

- (NSString *)getCurrentFormatTime;
- (void)setDuringTime:(NSInteger)duringTime_;

@end
