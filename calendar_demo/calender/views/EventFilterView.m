

#import "EventFilterView.h"

#import "Event.h"

@implementation EventFilterView {

    BOOL incompletedSelected;
    BOOL googleSelected;
    BOOL fbSelected;
    BOOL birthdaySelected;

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


+(EventFilterView *) createView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventFilterView" owner:self options:nil];
    EventFilterView * view = (EventFilterView*)[nibView objectAtIndex:0];

    view.btnImcompletedEvnt.selected = YES;
    view.btnGoogleEvnt.selected = YES;
    view.btnFBEvnt.selected = YES;
    view.btnBirthdayEvnt.selected = YES;
    
    return view;
}

-(IBAction) btnSelected:(id)sender
{

    UIButton * btn =  (UIButton *)sender;
    btn.selected = !btn.selected;
    
    int filters = 0x00000000;

    if(self.btnImcompletedEvnt.selected) {
        filters |= FILTER_IMCOMPLETE;
    }
    
    if(self.btnGoogleEvnt.selected) {
        filters |= FILTER_GOOGLE;
    }

    if(self.btnFBEvnt.selected) {
        filters |= FILTER_FB;
    }

    if(self.btnBirthdayEvnt.selected) {
        filters |= FILTER_BIRTHDAY;
    }

    if(self.delegate) {
        [self.delegate onFilterChanged:filters];
    }
}

-(void) setFilter:(int) filter
{
    self.btnImcompletedEvnt.selected = (filter & FILTER_IMCOMPLETE);
    self.btnGoogleEvnt.selected = (filter & FILTER_GOOGLE);
    self.btnFBEvnt.selected = (filter & FILTER_FB);
    self.btnBirthdayEvnt.selected = (filter & FILTER_BIRTHDAY);

}

@end
