

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
    //self.backgroundColor = [UIColor generateUIColorByHexString:@"#18a48b"];
}

-(void)setUpMainNavigationButtons:(ViewMode)mode
{
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 0, 10, 0);
//    UIImage *bgImage = [UIImage imageNamed:@"notification_btn.png"];
    UIImage *bgImage = [UIImage imageNamed:@"notification_grn.png"];
    //bgImage = [bgImage resizableImageWithCapInsets:insets];
    [self.leftBtn setImage:bgImage forState:UIControlStateNormal];
    [self.leftBtn setImageEdgeInsets:insets];
    
    if (mode == FEED_PENDING) {
        UIEdgeInsets insets2 = UIEdgeInsetsMake(0, 10, 10, 10);
        UIImage *rightBgImage = [UIImage imageNamed:@"add_event_icon_grn.png"];//add_event_icon.png"];
        rightBgImage = [rightBgImage resizableImageWithCapInsets:insets2];
        [self.rightBtn setImage:rightBgImage forState:UIControlStateNormal];
    } else if (mode == ACCOUNT_SETTING) {
        CGRect btnFrame = CGRectMake(250, 32, 80, 20);
        self.rightBtn.frame = btnFrame;
        
        UIColor * greenColor = [UIColor colorWithRed:61/255.0f green:173/255.0f blue:145/255.0f alpha:1];
        
        [self.rightBtn setTitleColor:greenColor forState:UIControlStateNormal];
        [self.rightBtn setTitle:@"Save" forState:UIControlStateNormal];
    }
    
}

+(Navigation *) createNavigationView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"Navigation" owner:self options:nil];
    Navigation * view = (Navigation*)[nibView objectAtIndex:0];
//    view.frame = CGRectMake(0, 0, 320, 64);
//
//    view.unreadCount.hidden =  YES;
//
//    view.unreadCount.layer.cornerRadius = view.unreadCount.frame.size.height/2;//设置那个圆角的有多圆
//    view.unreadCount.layer.masksToBounds = YES;//设为NO去试试
    
    //[view.calPendingSegment addTarget:self action:@selector(onSegmentPressed) forControlEvents:UIControlEventTouchUpInside];
    
//    UIEdgeInsets insets = UIEdgeInsetsMake(15, 12, 15, 0);
//    UIImage *image = view.leftBtn.imageView.image;
//    image = [image resizableImageWithCapInsets:insets];
//    view.leftBtn.imageEdgeInsets = insets;
    
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:15.f],UITextAttributeFont ,nil];
//    [view.calPendingSegment setTitleTextAttributes:dic forState:UIControlStateNormal];
    return view;
}

//-(void)onSegmentPressed
//{
//    
//}

@end
