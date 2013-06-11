#import "navigationNotifyCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation navigationNotifyCell
@synthesize headerIcon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

    }
    return self;
}

- (void)setHeaderIcon:(UIImageView *)_headerIcon
{
    if (headerIcon != _headerIcon) {
        [headerIcon release];
        headerIcon = [_headerIcon retain];
        
        [headerIcon.layer setCornerRadius:headerIcon.frame.size.width / 2];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self.contentView setBackgroundColor:[UIColor colorWithRed:65.0f/255.0f green:70.0f/255.0f blue:75.0f/255.0f alpha:1.0f]];
    self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [headerIcon release];
    [_NotifyDetailLabel release];
    [_notifyDateLabel release];
    [super dealloc];
}
@end
