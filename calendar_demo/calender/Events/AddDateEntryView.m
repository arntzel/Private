#import "AddDateEntryView.h"

@implementation AddDateEntryView

- (void)initUI
{
    [self setUserInteractionEnabled:YES];
    UIImage *bgImage = [UIImage imageNamed:@"addEventBtnBg.png"];
    bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [_DateResultView setImage:bgImage];
    [_AddDateView setImage:bgImage];
}

+(AddDateEntryView *) createDateEntryView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"AddDateEntryView" owner:self options:nil];
    AddDateEntryView * view = (AddDateEntryView*)[nibView objectAtIndex:0];
    [view initUI];
    return view;
}

- (void)dealloc {
    [_DateResultView release];
    [_AddDateView release];
    [_btnAddDate release];
    [super dealloc];
}
@end
