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
    [self setBackgroundColor:[UIColor clearColor]];
    //[self.contentView setBackgroundColor:[UIColor colorWithRed:65.0f/255.0f green:70.0f/255.0f blue:75.0f/255.0f alpha:1.0f]];
    //self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
    
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
    //UIFont *font = [UIFont systemFontOfSize:11];
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
//        [self.NotifyDetailLabel setColor:[UIColor colorWithRed:237.0/255.0f green:237.0/255.0f blue:237.0/255.0f alpha:1.0] fromIndex:0 length:subject.length];
//    [self.NotifyDetailLabel setFont:font fromIndex:0 length:subject.length];
    //[self.NotifyDetailLabel setFont:[UIFont boldSystemFontOfSize:12] fromIndex:0 length:4];
    //[self.NotifyDetailLabel setFont:[UIFont boldSystemFontOfSize:12] fromIndex:20 length:8];
    CGSize maxSize = CGSizeMake(self.NotifyDetailLabel.frame.size.width, 1000.0f);
    CGSize fontSize = [subject sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
    [self.NotifyDetailLabel setNumberOfLines:0];
    
    CGRect strFrame = CGRectMake(60, 18, 210, fontSize.height);
    self.NotifyDetailLabel.frame = strFrame;
    
//    CGRect frame = self.frame;
//    frame.size.height = fontSize.height + 32;
//    self.frame = frame;
    
    self.NotifyDetailLabel.text = subject;
    [self.NotifyDetailLabel setFont:font];
    [self.NotifyDetailLabel setTextColor:[UIColor whiteColor]];
    
    //[self.NotifyDetailLabel setTextColor:[UIColor colorWithRed:237.0/255.0f green:237.0/255.0f blue:237.0/255.0f alpha:1.0]];
    
//    CGRect frame = self.NotifyDetailLabel.frame;
//    frame.size = fontSize;
//    self.NotifyDetailLabel.frame = frame;



    UIFont *font2 = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
    self.notifyDateLabel.font = font2;
    self.notifyDateLabel.text = [Utils getTimeText:msg.sendTime];
    
    CGRect dateLabel = self.notifyDateLabel.frame;
    if (fontSize.height > 33) {
        dateLabel.origin.y = self.NotifyDetailLabel.frame.origin.y + fontSize.height;
    } else {
        dateLabel.origin.y = self.NotifyDetailLabel.frame.origin.y + fontSize.height + 10;
        CGRect detailLabelFrame = self.NotifyDetailLabel.frame;
        detailLabelFrame.origin.y += 10;
        self.NotifyDetailLabel.frame = detailLabelFrame;
    }
    
    self.notifyDateLabel.frame = dateLabel;
    
    if([msg.unread boolValue]) {
        self.notifyDateLabel.textColor = [UIColor whiteColor];
    }
}


@end
