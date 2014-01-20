
#import <UIKit/UIKit.h>
#import "CustomSwitch.h"

@interface AddEventSettingView : UIView
@property (retain, nonatomic) IBOutlet UIImageView *view1;
@property (retain, nonatomic) IBOutlet UIImageView *view2;
@property (retain, nonatomic) IBOutlet UIImageView *view3;

+(AddEventSettingView *) createEventSettingView;

- (IBAction)proposeDaysClick:(id)sender;
- (IBAction)onlyProposeDaysClick:(id)sender;
- (IBAction)onlyProposeTimes:(id)sender;
- (IBAction)canntProposeDaysClick:(id)sender;

-(IBAction) onTimezoneClick:(id)sender;

@property (retain, nonatomic) IBOutlet CustomSwitch *canInvitePeopleSwitch;
@property (retain, nonatomic) IBOutlet CustomSwitch *canChangeLocation;

@property (retain, nonatomic) IBOutlet UILabel *timeZoneLabel;


@property (retain, nonatomic) IBOutlet UIButton *btnInvite1;
@property (retain, nonatomic) IBOutlet UIButton *btnInvite2;
@property (retain, nonatomic) IBOutlet UIButton *btnInvite3;
@property (retain, nonatomic) IBOutlet UIButton *btnInvite4;


@end
