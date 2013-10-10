

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
    [self.agreeTimeMark setHidden:YES];
    [self.agreeTimeLabel setHidden:YES];
    [self.declindTimeMark setHidden:YES];
    [self.declindTimeLabel setHidden:YES];
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

- (void)upUserNamePlace
{
    CGRect frame = self.peopleName.frame;
    frame.origin.y = self.peopleHeader.frame.origin.y;
    self.peopleName.frame = frame;
}

- (void)setAgreeTime:(NSArray*)array
{
    if ([array count] > 0) {
        [self.agreeTimeMark setHidden:NO];
        [self.agreeTimeLabel setHidden:NO];
        [self upUserNamePlace];
        
        CGRect frame = self.agreeTimeMark.frame;
        frame.origin.y = self.peopleName.frame.origin.y + self.peopleName.frame.size.height + 7;
        self.agreeTimeMark.frame = frame;
        
        frame = self.agreeTimeLabel.frame;
        frame.origin.y = self.peopleName.frame.origin.y + self.peopleName.frame.size.height + 4;
        self.agreeTimeLabel.frame = frame;
        
        
        
        frame = self.frame;
        frame.size.height = self.agreeTimeLabel.frame.origin.y + self.agreeTimeLabel.frame.size.height + 10;
        self.frame = frame;
        

        self.agreeTimeLabel.text = [self getTimesLabel:array];
    }
}

- (void)setDeclindTime:(NSArray*)array
{
    if ([array count] > 0) {
        [self.declindTimeMark setHidden:NO];
        [self.declindTimeLabel setHidden:NO];
        if (self.agreeTimeLabel.hidden == YES) {
            [self upUserNamePlace];
            
            CGRect frame = self.declindTimeMark.frame;
            frame.origin.y = self.peopleName.frame.origin.y + self.peopleName.frame.size.height + 7;
            self.declindTimeMark.frame = frame;
            
            frame = self.declindTimeLabel.frame;
            frame.origin.y = self.peopleName.frame.origin.y + self.peopleName.frame.size.height + 4;
            self.declindTimeLabel.frame = frame;
            
            frame = self.frame;
            frame.size.height = self.declindTimeLabel.frame.origin.y + self.declindTimeLabel.frame.size.height + 10;
            self.frame = frame;
        }
        else
        {
            CGRect frame = self.declindTimeMark.frame;
            frame.origin.y = self.agreeTimeLabel.frame.origin.y + self.agreeTimeLabel.frame.size.height + 7;
            self.declindTimeMark.frame = frame;
            
            frame = self.declindTimeLabel.frame;
            frame.origin.y = self.agreeTimeLabel.frame.origin.y + self.agreeTimeLabel.frame.size.height + 4;
            self.declindTimeLabel.frame = frame;
            
            frame = self.frame;
            frame.size.height = self.declindTimeLabel.frame.origin.y + self.declindTimeLabel.frame.size.height + 10;
            self.frame = frame;
        }
        
        self.declindTimeLabel.text = [self getTimesLabel:array];
    }
}

-(NSString *) getTimesLabel:(NSArray *) times
{
    NSMutableString * label = [[NSMutableString alloc] init];
    
    for (int i=0; i<times.count;i++) {
        [label appendString: [times objectAtIndex:i]];
        if(i != times.count-1) {
            [label appendString: @", "];
        }
    }

    return label;
}
@end
