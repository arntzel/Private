

#import "DetailRespondedCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

@interface DetailRespondedCell()

@property (retain, nonatomic) IBOutlet UIImageView * peopleHeader;
@property (retain, nonatomic) IBOutlet UILabel * peopleName;
@property (weak, nonatomic) IBOutlet UIImageView *agreeTimeMark;
@property (weak, nonatomic) IBOutlet UIImageView *declindTimeMark;
@property (weak, nonatomic) IBOutlet UILabel *agreeTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *declindTimeLabel;

@end

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

- (void)setHeaderImage:(UIImage *)image
{
    self.peopleHeader.image = image;
}

- (void)setHeaderImageUrl:(NSString *)url
{
    [self.peopleHeader setImageWithURL:[NSURL URLWithString:url]];
}

- (void)setName:(NSString *)name
{
    self.peopleName.text = name;
}

- (void)setAgreeTime:(NSArray*)array
{
    
}

- (void)setDeclindTime:(NSArray*)array
{
    
}

@end
