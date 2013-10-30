
#import <UIKit/UIKit.h>

#import "ProposeStart.h"

@protocol AddEventTimesViewDelegate <NSObject>

- (void)layOutSubViews;

@end


@interface AddEventTimesView : UIView

@property(nonatomic,assign) id<AddEventTimesViewDelegate> delegate;

-(void)addBtnTarget:(id)target action:(SEL)action;

-(void) addEventDate:(ProposeStart *) eventDate;

-(void) updateView:(NSArray *) eventDates;

-(NSArray *) getEventDates;

@end
