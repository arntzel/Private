

#import <UIKit/UIKit.h>


@protocol EventFilterViewDelegate <NSObject>

-(void) onFilterChanged:(int)filters;

@end


@interface EventFilterView : UIView

@property(strong) IBOutlet UIButton * btnImcompletedEvnt;

@property(strong) IBOutlet UIButton * btnGoogleEvnt;

@property(strong) IBOutlet UIButton * btnFBEvnt;

@property(strong) IBOutlet UIButton * btnBirthdayEvnt;

-(IBAction) btnSelected:(id)sender;

-(void) setFilter:(int) filter;


@property(nonatomic, assign) id<EventFilterViewDelegate> delegate;

+(EventFilterView *) createView;

@end
