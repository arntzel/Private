
#import "CustomerIndicatorView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>


@implementation CustomerIndicatorView {

    UIActivityIndicatorView * indicatorView;

}

-(id) init {
    self = [super initWithFrame:CGRectMake(0, 0, 30, 30)];
    if (self) {

        self.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        self.layer.cornerRadius = 15;
        self.layer.masksToBounds = YES;


        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicatorView.hidesWhenStopped = NO;
        indicatorView.center = self.center;
        [self addSubview:indicatorView];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    assert(NO);
    return nil;
}

-(void) startAnim
{
    [indicatorView startAnimating];
}

-(void) stopAnim
{
    [indicatorView stopAnimating];
}

@end
