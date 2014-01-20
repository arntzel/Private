#import "AddEventNavigationBar.h"
#import "UIColor+Hex.h"

@implementation AddEventNavigationBar
@synthesize delegate;

- (void)dealloc {

}

- (IBAction)leftBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(leftBtnPress:)]) {
        [self.delegate leftBtnPress:sender];
    }
}

- (IBAction)rightBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(rightBtnPress:)]) {
        [self.delegate rightBtnPress:sender];
    }
}

-(void) setRightBtnEnable:(BOOL) enable
{
    self.rightbtn.enabled = enable;
}

+(AddEventNavigationBar *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"AddEventNavigationBar" owner:self options:nil];
    AddEventNavigationBar * view = (AddEventNavigationBar*)[nibView objectAtIndex:0];
    return view;
}

@end
