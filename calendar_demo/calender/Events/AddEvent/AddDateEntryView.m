#import "AddDateEntryView.h"

@implementation AddDateEntryView
@synthesize delegate;

- (void)awakeFromNib
{
    [self setUserInteractionEnabled:YES];
    UIImage *bgImage = [UIImage imageNamed:@"addEventBtnBg.png"];
    bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [_DateResultView setImage:bgImage];
}

+(AddDateEntryView *) createDateEntryView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"AddDateEntryView" owner:self options:nil];
    AddDateEntryView * view = (AddDateEntryView*)[nibView objectAtIndex:0];
    return view;
}

- (IBAction)remove:(id)sender {
    if ([self.delegate respondsToSelector:@selector(removeEventDataView:)]) {
        [self.delegate removeEventDataView:self];
    }
}


- (void)dealloc {
    self.eventData = nil;
    [_DateResultView release];
    [_startTimeLabel release];
    [_duringTimeLabel release];
    
    [super dealloc];
}
@end
