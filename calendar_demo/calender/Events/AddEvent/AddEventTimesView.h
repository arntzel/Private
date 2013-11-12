
#import <UIKit/UIKit.h>

#import "ProposeStart.h"

@protocol AddEventTimesViewDelegate <NSObject>

- (void)layOutSubViews;

- (void)updateDate:(ProposeStart *)eventData;

@end


@interface AddEventTimesView : UIView

@property(nonatomic,assign) id<AddEventTimesViewDelegate> delegate;

-(void)addBtnTarget:(id)target action:(SEL)action;

-(void) addEventDate:(ProposeStart *) eventDate;

-(void) updateView:(NSArray *) eventDates;

- (void)updateEventData:(ProposeStart *)eventData;

-(NSArray *) getEventDates;

@end
