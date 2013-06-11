
#import "navigationMenuCell.h"

@implementation navigationMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self.contentView setBackgroundColor:[UIColor colorWithRed:65.0f/255.0f green:70.0f/255.0f blue:75.0f/255.0f alpha:1.0f]];
//    self.selectedBackgroundView = [[[UIView alloc] initWithFrame:self.frame] autorelease];
//    self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_iconImageView release];
    [_titleLabel release];
    [_detailImageView release];
    [super dealloc];
}
@end
