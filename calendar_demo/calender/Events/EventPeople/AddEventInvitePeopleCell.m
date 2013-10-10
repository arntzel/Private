

#import "AddEventInvitePeopleCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

@implementation AddEventInvitePeople
- (void)dealloc
{
    self.user = nil;
    [super dealloc];
}
@end


@implementation AddEventInvitePeopleCell

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

- (void) refreshView: (AddEventInvitePeople*) iuser
{
    if(iuser == nil) {
        self.labNoData.hidden = NO;
        return;
    } else {
        self.labNoData.hidden = YES;
    }
    
    [self setSelectionStyle:UITableViewCellSelectionStyleDefault];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
    self.selectedBackgroundView = view;
    [view setBackgroundColor:[UIColor clearColor]];
    
    Contact * user = iuser.user;
    
    self.peopleName.text = [user getReadableUsername];
    
    NSString * headerUrl = user.avatar_url;
    
    if(headerUrl == nil) {
        self.peopleHeader.image = [UIImage imageNamed:@"header.png"];
    } else {
        [self.peopleHeader setImageWithURL:[NSURL URLWithString:headerUrl]
                          placeholderImage:[UIImage imageNamed:@"header.png"]];
    }

    //self.btnSelect.selected = iuser.selected;
    
    if(iuser.selected) {
        self.btnSelect.image = [UIImage imageNamed:@"btn_ok_selected"];
    } else {
        self.btnSelect.image = [UIImage imageNamed:@"btn_ok"];
    }    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:NO];
}

- (void)setHeaderImageUrl:(NSString *)url
{
     [self.peopleHeader setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"header.png"]];
}

@end
