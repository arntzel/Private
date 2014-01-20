#import "CStartTimeTitle.h"

@interface CStartTimeTitle()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation CStartTimeTitle
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setTime:(NSString *)timeString
{
    self.timeLabel.text = timeString;
}

- (void)awakeFromNib
{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapTimeView:)];
    [self addGestureRecognizer:gesture];
    [self setBackgroundColor:[UIColor colorWithRed:225/255.0f green:225/255.0f blue:225/255.0f alpha:1.0f]];
}

-(void) singleTapTimeView:(UITapGestureRecognizer*) tap
{
    if ([self.delegate respondsToSelector:@selector(didTapdView:)]) {
        [self.delegate didTapdView:self];
    }
}

@end
