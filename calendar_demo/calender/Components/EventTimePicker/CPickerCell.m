#import "CPickerCell.h"

@implementation CPickerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)initUI
{
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    [self.selectedBackgroundView setBackgroundColor:[UIColor clearColor]];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    [self setBackgroundColor:[UIColor clearColor]];
//    [self setBackgroundColor:[UIColor colorWithRed:225/255.0f green:225/255.0f blue:225/255.0f alpha:1.0f]];
    
    self.label.textColor = [UIColor colorWithRed:73/255.0f green:73/255.0f blue:73/255.0f alpha:1.0f];
}

- (void)setMasked:(BOOL)masked
{
    if (masked)
    {
        self.label.textColor = [UIColor colorWithRed:21/255.0f green:155/255.0f blue:131/255.0f alpha:1.0f];
//        self.label.textColor = [UIColor redColor];
    }
    else
    {
        self.label.textColor = [UIColor colorWithRed:73/255.0f green:73/255.0f blue:73/255.0f alpha:1.0f];
//        self.label.textColor = [UIColor blackColor];
    }
}

//- (void)setFrame:(CGRect)frame
//{
//    [super setFrame:frame];
//    [self.label setFrame:self.bounds];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    [self.label setTextAlignment:textAlignment];
}
@end
