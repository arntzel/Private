
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



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    NSLog(@"setSelected:%d", selected);
    
    // Configure the view for the selected state
}

- (void)dealloc {
    [_iconImageView release];
    [_titleLabel release];
    [_detailImageView release];
    [super dealloc];
}
@end
