

#import "DetailRespondedCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

@implementation DetailRespondedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)awakeFromNib
{
    self.peopleHeader.layer.cornerRadius = self.peopleHeader.frame.size.width/2;
    self.peopleHeader.layer.masksToBounds = YES;
}

@end
