#import "navigationNotifyCell.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

#import "Utils.h"

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

-(void) refreshView:(MessageEntity *) msg
{
    NSString * headerUrl = msg.senderUrl;
    
    if(headerUrl == nil) {
        self.headerIcon.image = [UIImage imageNamed:@"header.png"];
    } else {
        [self.headerIcon setImageWithURL:[NSURL URLWithString:headerUrl]
                     placeholderImage:[UIImage imageNamed:@"header.png"]];
    }
    
    
    NSString * subject = msg.subject;
    
    self.NotifyDetailLabel.text = subject;
    
    [self.NotifyDetailLabel setColor:[UIColor colorWithRed:237.0/255.0f green:237.0/255.0f blue:237.0/255.0f alpha:1.0] fromIndex:0 length:subject.length];
    
    [self.NotifyDetailLabel setFont:[UIFont systemFontOfSize:11] fromIndex:0 length:subject.length];
    //[self.NotifyDetailLabel setFont:[UIFont boldSystemFontOfSize:12] fromIndex:0 length:4];
    //[self.NotifyDetailLabel setFont:[UIFont boldSystemFontOfSize:12] fromIndex:20 length:8];

    self.notifyDateLabel.text = [Utils getTimeText:msg.sendTime];
    
    if([msg.unread boolValue]) {
        self.notifyDateLabel.textColor = [UIColor redColor];
    }
}


@end
