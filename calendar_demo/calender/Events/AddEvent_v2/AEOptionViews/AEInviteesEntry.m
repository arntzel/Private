#import "AEInviteesEntry.h"
#import <QuartzCore/QuartzCore.h>


@interface AEInviteesEntry()

@property (weak, nonatomic) IBOutlet UIView *monthDayView;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end


@implementation AEInviteesEntry
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)awakeFromNib
{
    [self.monthDayView setBackgroundColor:[UIColor colorWithRed:53/255.0f green:162/255.0f blue:144/255.0f alpha:1.0f]];
    [self.monthDayView.layer setCornerRadius:self.monthDayView.frame.size.height / 2];
    self.title.textColor = [UIColor colorWithRed:116/255.0f green:116/255.0f blue:116/255.0f alpha:1.0f];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapTimeView:)];
    [self addGestureRecognizer:gesture];
    
    
    UIView * line  = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    line.alpha = 0.5f;
    [self addSubview:line];
    
    [self setBackgroundColor:[UIColor colorWithRed:233/255.0f green:240/255.0f blue:234/255.0f alpha:1.0f]];
}

-(void) singleTapTimeView:(UITapGestureRecognizer*) tap
{
    if ([self.delegate respondsToSelector:@selector(didTapdView:)]) {
        [self.delegate didTapdView:self];
    }
}


+(AEInviteesEntry *) createView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"AEInviteesEntry" owner:self options:nil];
    AEInviteesEntry * view = (AEInviteesEntry*)[nibView objectAtIndex:0];
    
    return view;
}
@end