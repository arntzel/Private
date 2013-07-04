

#import <UIKit/UIKit.h>

#define EventFilterViewHeight 275

#define FILTER_IMCOMPLETE  0X00000001
#define FILTER_GOOGLE      0X00000002
#define FILTER_FB          0X00000004
#define FILTER_BIRTHDAY    0X00000008


@protocol EventFilterViewDelegate <NSObject>

-(void) onFilterChanged:(int)filters;

@end


@interface EventFilterView : UIView

@property(strong) IBOutlet UIButton * btnImcompletedEvnt;

@property(strong) IBOutlet UIButton * btnGoogleEvnt;

@property(strong) IBOutlet UIButton * btnFBEvnt;

@property(strong) IBOutlet UIButton * btnBirthdayEvnt;

-(IBAction) btnSelected:(id)sender;


@property(nonatomic, assign) id<EventFilterViewDelegate> delegate;

+(EventFilterView *) createView;

@end
