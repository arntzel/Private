
#import "EventDetailViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>


@interface EventDetailViewController ()

@end

@implementation EventDetailViewController {
    Event * _event;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString * url = _event.thumbnail_url;

    NSLog(@"EventDetailViewController: url=%@", url);

    if(![url isKindOfClass: [NSNull class]]) {

        [self.imgView setImageWithURL:[NSURL URLWithString:url]
                     placeholderImage:[UIImage imageNamed:@"imagePicker_bg.jpg"]];
    } else {
        self.imgView.image = [UIImage imageNamed:@"imagePicker_bg.jpg"];
    }
}


-(IBAction) back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) setEvent:(Event*)event
{
    _event = event;
}




@end
