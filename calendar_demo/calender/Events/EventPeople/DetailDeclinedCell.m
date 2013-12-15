

#import "DetailDeclinedCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>



@implementation DetailDeclinedCell

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

- (void)setHeaderImage:(UIImage *)image
{
    self.peopleHeader.image = image;
}

- (void)setHeaderImageUrl:(NSString *)url
{
     [self.peopleHeader setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"header.png"]];
}

- (void)setName:(NSString *)name
{
    self.peopleName.text = name;
}

- (void)setDeclinedTimeString:(NSString *)declinedTimeString
{
    self.declinedTime.text = declinedTimeString;
}
@end
