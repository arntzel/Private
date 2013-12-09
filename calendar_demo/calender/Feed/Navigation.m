

#import "Navigation.h"
#import "UIColor+Hex.h"
#import <QuartzCore/QuartzCore.h>

@implementation Navigation

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//-(id) initWithCoder:(NSCoder *)aDecoder {
//    self = [super initWithCoder:aDecoder];
//    
//    
//    
//    return self;
//}
//
-(void) awakeFromNib {
    LOG_D(@"awakeFromNib");
    self.backgroundColor = [UIColor generateUIColorByHexString:@"#18a48b"];
}

-(void)setUpMainNavigationButtons
{
    UIEdgeInsets insets = UIEdgeInsetsMake(15, 12, 15, 0);
    UIImage *bgImage = [UIImage imageNamed:@"menu_icon.png"];
    bgImage = [bgImage resizableImageWithCapInsets:insets];
    [self.leftBtn setImage:bgImage forState:UIControlStateNormal];
    
    UIEdgeInsets insets2 = UIEdgeInsetsMake(10, 0, 10, 10);
    UIImage *rightBgImage = [UIImage imageNamed:@"add_event_icon.png"];
    rightBgImage = [rightBgImage resizableImageWithCapInsets:insets2];
    [self.rightBtn setImage:rightBgImage forState:UIControlStateNormal];
}

+(Navigation *) createNavigationView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"Navigation" owner:self options:nil];
    Navigation * view = (Navigation*)[nibView objectAtIndex:0];
    view.frame = CGRectMake(0, 0, 320, 64);

    view.unreadCount.hidden = YES;

    view.unreadCount.layer.cornerRadius = 6;//设置那个圆角的有多圆
    view.unreadCount.layer.masksToBounds = YES;//设为NO去试试
    
    //[view.calPendingSegment addTarget:self action:@selector(onSegmentPressed) forControlEvents:UIControlEventTouchUpInside];
    
//    UIEdgeInsets insets = UIEdgeInsetsMake(15, 12, 15, 0);
//    UIImage *image = view.leftBtn.imageView.image;
//    image = [image resizableImageWithCapInsets:insets];
//    view.leftBtn.imageEdgeInsets = insets;

    return view;
}

//-(void)onSegmentPressed
//{
//    
//}

@end
