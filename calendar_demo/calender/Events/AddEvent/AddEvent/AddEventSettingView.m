
#import "AddEventSettingView.h"
#import "SelectTimeZoneController.h"
#import "RootNavContrller.h"
#import "UserModel.h"

@interface AddEventSettingView () <SelectTimeZoneControllerDelegate>

@end

@implementation AddEventSettingView

- (void)initUI
{
    [self setUserInteractionEnabled:YES];
//    UIImage *bgImage = [UIImage imageNamed:@"addEventBtnBg.png"];
//    bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
//    [_view1 setImage:bgImage];
//    [_view2 setImage:bgImage];
//    [_view3 setImage:bgImage];
    
    CGRect frame = self.canInvitePeopleSwitch.frame;
    [self.canInvitePeopleSwitch removeFromSuperview];
    self.canInvitePeopleSwitch = [[CustomSwitch alloc] initWithFrame:frame segmentCount:2];
    [self.canInvitePeopleSwitch setSegTitle:@"Yes" AtIndex:0];
    [self.canInvitePeopleSwitch setSegTitle:@"No" AtIndex:1];
    [_view2 addSubview:self.canInvitePeopleSwitch];
    
    frame = self.canChangeLocation.frame;
    [self.canChangeLocation removeFromSuperview];
    self.canChangeLocation = [[CustomSwitch alloc] initWithFrame:frame segmentCount:2];
    [self.canChangeLocation setSegTitle:@"Yes" AtIndex:0];
    [self.canChangeLocation setSegTitle:@"No" AtIndex:1];
    [_view2 addSubview:self.canChangeLocation];

    /*
    NSString * timezone = [self getRecentTimezone];
    if(timezone == nil) {
        timezone = @"America/New_York";
    }
    self.timeZoneLabel.text = timezone;
    */

    self.timeZoneLabel.text = [[UserModel getInstance] getLoginUser].timezone;
    
//    [self.canInvitePeopleSwitch addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
}

+(AddEventSettingView *) createEventSettingView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"AddEventSettingView" owner:self options:nil];
    AddEventSettingView * view = (AddEventSettingView*)[nibView objectAtIndex:0];
    [view initUI];
    return view;
}

- (IBAction)proposeDaysClick:(id)sender {
    [self reversSelectBtn:sender];
}

- (IBAction)onlyProposeDaysClick:(id)sender {
    [self reversSelectBtn:sender];
}

- (IBAction)onlyProposeTimes:(id)sender {
    [self reversSelectBtn:sender];
}

- (IBAction)canntProposeDaysClick:(id)sender {
    [self reversSelectBtn:sender];
}

-(IBAction) onTimezoneClick:(id)sender
{
    SelectTimeZoneController * ctr = [[SelectTimeZoneController alloc] init];
    ctr.delegate = self;
    [[RootNavContrller defaultInstance] pushViewController:ctr animated:YES];
    [ctr release];
}

-(void) onSelectedTimezone:(NSString *) timezone
{
    self.timeZoneLabel.text = timezone;
    //[self saveTimezone:timezone];
}

- (void)reversSelectBtn:(UIButton *)btn
{
    self.btnInvite1.selected =  (self.btnInvite1== btn);
    self.btnInvite2.selected =  (self.btnInvite2== btn);
    self.btnInvite3.selected =  (self.btnInvite3== btn);
    self.btnInvite4.selected =  (self.btnInvite4== btn);
}

- (void)dealloc {
    self.canChangeLocation = nil;
    self.canInvitePeopleSwitch = nil;
    
    self.btnInvite1 = nil;
    self.btnInvite2 = nil;
    self.btnInvite3 = nil;
    self.btnInvite4 = nil;
    
    [_view1 release];
    [_view2 release];
    [_view3 release];
    [super dealloc];
}

//-(NSString *) getRecentTimezone
//{
//    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
//    return [defaults objectForKey:@"timezone"];
//}
//
//-(void) saveTimezone:(NSString *) timezone
//{
//     NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
//    [defaults setObject:timezone forKey:@"timezone"];
//    [defaults synchronize];
//}

@end
