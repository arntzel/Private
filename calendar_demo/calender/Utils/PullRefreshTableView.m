
#import "PullRefreshTableView.h"
#import <QuartzCore/QuartzCore.h>


#define REFRESH_HEADER_HEIGHT 52.0f

enum {
    MRPullView_Pull,
    MRPullView_Release,
    MRPullView_Loading
};

@interface MRPullView : UIView
{
    UILabel *label;
    UIImageView *arrow;
    UIActivityIndicatorView *spinner;
}

@property (nonatomic, assign) BOOL isHeader;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, copy) NSString *pullText;
@property (nonatomic, copy) NSString *releaseText;
@property (nonatomic, copy) NSString *loadingText;

- (void)startLoading;
- (void)stopLoading;
- (void)stopLoadingComplete;
- (void)setPhase:(NSInteger)type;

@end

@implementation MRPullView

@synthesize isHeader = _isHeader;
@synthesize isLoading = _isLoading;
@synthesize pullText = _pullText;
@synthesize releaseText = _releaseText;
@synthesize loadingText = _loadingText;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initSubviews];
    }
    return self;
}


- (void)setIsHeader:(BOOL)isHeader
{
    CATransform3D transform;
    if (isHeader) {
        transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        transform = CATransform3DTranslate(transform, 0, 3, 0);
        arrow.layer.transform = transform;
    } else {
        //[label removeFromSuperview]; label = nil;
        [arrow removeFromSuperview]; arrow = nil;
        //spinner.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    }
    _isHeader = isHeader;
}

- (void)startLoading
{
    label.text = self.loadingText;
    arrow.hidden = YES;
    [spinner startAnimating];
}

- (void)stopLoading
{
    arrow.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
}

- (void)stopLoadingComplete
{
    label.text = self.pullText;
    arrow.hidden = NO;
    [spinner stopAnimating];
    self.isLoading = NO;
}

- (void)setPhase:(NSInteger)type
{
    CATransform3D transform;
    switch (type) {
        case MRPullView_Pull:
            label.text = self.pullText;
            if (self.isHeader) {
                transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
                transform = CATransform3DTranslate(transform, 0, 3, 0);
                arrow.layer.transform = transform;
            }
            break;
        case MRPullView_Release:
            label.text = self.releaseText;
            if (self.isHeader) {
                transform = CATransform3DMakeRotation(0, 0, 0, 1);
                transform = CATransform3DTranslate(transform, 0, 7, 0);
                arrow.layer.transform = transform;
            }
            break;
        case MRPullView_Loading:
            break;
        default:
            LOG_D(@"setLabel param error!");
            break;
    }
}

- (void)initSubviews
{
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    
    arrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 28)];
    arrow.center = CGPointMake(36, REFRESH_HEADER_HEIGHT / 2);
    arrow.image = [UIImage imageNamed:@"pull_arrow.png"];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinner.center = CGPointMake(36, REFRESH_HEADER_HEIGHT / 2);
    spinner.hidesWhenStopped = YES;
    spinner.color = label.textColor;
    
    [self addSubview:label];
    [self addSubview:arrow];
    [self addSubview:spinner];
}
@end




@interface PullRefreshTableView () <UIScrollViewDelegate>
{
    MRPullView *header;
    MRPullView *tailer;
    BOOL isDragging;
    BOOL isDragHeader;
}

@end

@implementation PullRefreshTableView

@synthesize headerEnabled = _headerEnabled;
@synthesize tailerEnabled = _tailerEnabled;
@synthesize upTimes;
@synthesize downTimes;

- (id)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {
        self.upTimes = 0;
        self.downTimes = 0;
        [self addPullHeader];
        [self addPullTailer];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.upTimes = 0;
        self.downTimes = 0;
        [self addPullHeader];
        [self addPullTailer];
    }
    return self;
}

- (void)reloadData
{
    [super reloadData];
    tailer.frame = CGRectMake(0, self.contentSize.height - 6, 320, REFRESH_HEADER_HEIGHT);
}

- (void)setHeaderEnabled:(BOOL)headerEnabled
{
    header.hidden = (headerEnabled != YES);
    _headerEnabled = headerEnabled;
}

- (void)setTailerEnabled:(BOOL)tailerEnabled
{

    tailer.hidden = (tailerEnabled != YES);
    _tailerEnabled = tailerEnabled;
}

-(BOOL) isLoading
{
    return header.isLoading || tailer.isLoading;
}

- (void)startHeaderLoading
{
    if ([self isLoading]) {
        return;
    }

    isDragHeader = YES;
    [self startPullLoading];
}

- (void)startTailerLoading
{
    if ([self isLoading]) {
        return;
    }

    isDragHeader = NO;
    [self startPullLoading];
}

#pragma mark * Internal Methods
- (void)addPullHeader
{
    header = [[MRPullView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT + 6, 320, REFRESH_HEADER_HEIGHT)];
    header.pullText = [NSString stringWithFormat:@"Pull to refresh..."];
    header.releaseText = [NSString stringWithFormat:@"Release to refresh..."];
    header.loadingText = [NSString stringWithFormat:@"Loading..."];
    header.isHeader = YES;
    [self addSubview:header];
}

- (void)addPullTailer
{
    tailer = [[MRPullView alloc] initWithFrame:CGRectMake(0, - REFRESH_HEADER_HEIGHT + 6, 320, REFRESH_HEADER_HEIGHT)];
    tailer.pullText = [NSString stringWithFormat:@"Pull to refresh..."];
    tailer.releaseText = [NSString stringWithFormat:@"Release to refresh..."];
    tailer.loadingText = [NSString stringWithFormat:@"Loading..."];
    tailer.isHeader = NO;
    [self addSubview:tailer];
}



- (void)startPullLoading
{
    MRPullView *pull = nil;
    UIEdgeInsets insets;
    if (isDragHeader) {
        pull = header;
        //insets = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        insets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.downTimes +=1;

        tailer.hidden = YES;
    } else {
        pull = tailer;
        insets = UIEdgeInsetsMake(0, 0, REFRESH_HEADER_HEIGHT, 0);
        self.upTimes +=1;

        header.hidden = YES;
    }
    
    pull.isLoading = YES;
    pull.hidden = NO;
    
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [pull startLoading];
    self.contentInset = insets;
    
    
    [UIView commitAnimations];

    // Refresh action!
    [self doStartLoad:isDragHeader];
}

- (void)stopPullLoading
{
    MRPullView *pull;
    if (isDragHeader) {
        pull = header;
    } else {
        pull = tailer;
    }
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopHeaderLoadingComplete:finished:context:)];
    self.contentInset = UIEdgeInsetsZero;
    [pull stopLoading];
    [UIView commitAnimations];

    if(self.pullRefreshDalegate) {
        [self.pullRefreshDalegate onPullStop];
    }
}

- (void)pullStarted
{
    if(self.pullRefreshDalegate) {
        [self.pullRefreshDalegate onPullStarted];
    }
}

- (void)pullCancelled
{
    if(self.pullRefreshDalegate) {
        [self.pullRefreshDalegate onPullCancelled];
    }
}

- (void)stopHeaderLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    // Reset the header
    if (isDragHeader) {
        if (self.tailerEnabled) {
            tailer.hidden = NO;
        }
        [header stopLoadingComplete];
    } else {
        if (self.headerEnabled) {
            header.hidden = NO;
        }
        [tailer stopLoadingComplete];
    }
    isDragHeader = NO;
}

- (void)doStartLoad:(BOOL)head
{
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopXXXXLoading at the end.

    if(self.pullRefreshDalegate) {
        [self.pullRefreshDalegate onStartLoadData:head];
    } else {
        [self performSelector:@selector(stopPullLoading) withObject:nil afterDelay:2.0];
    }
}

#pragma mark * UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ( [self isLoading]) {
        return;
    }
    isDragging = YES;
    [self pullStarted];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

#if 0
    if (header.isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0){
            //self.contentInset = UIEdgeInsetsZero;
        }else if (scrollView.contentOffset.y >= CGRectGetMinY(header.frame)){
            LOG_D(@"head offset: %f", scrollView.contentOffset.y);
            //self.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
    } else if (tailer.isLoading) {
        if (scrollView.contentOffset.y < CGRectGetMinY(tailer.frame) - CGRectGetHeight(self.frame)) {
            //self.contentInset = UIEdgeInsetsZero;
        } else if (scrollView.contentOffset.y <= CGRectGetMaxY(tailer.frame) - CGRectGetHeight(self.frame)) {
            LOG_D(@"tail offset: %f", scrollView.contentOffset.y);
            //self.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetMaxY(tailer.frame) - CGRectGetHeight(self.frame) - scrollView.contentOffset.y, 0);
        }
    } else
#endif
    if (isDragging) {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if (header.hidden != YES && scrollView.contentOffset.y < 0) {
            if (scrollView.contentOffset.y < CGRectGetMinY(header.frame)) {
                // User is scrolling above the header
                [header setPhase:MRPullView_Release];
            } else { // User is scrolling somewhere within the header
                [header setPhase:MRPullView_Pull];
            }
            isDragHeader = YES;
        } else if (tailer.hidden != YES && scrollView.contentOffset.y > CGRectGetMinY(tailer.frame) - CGRectGetHeight(self.frame)) {
            if (scrollView.contentOffset.y > CGRectGetMaxY(tailer.frame) - CGRectGetHeight(self.frame)) {
                [tailer setPhase:MRPullView_Release];
            } else {
                [tailer setPhase:MRPullView_Pull];
            }
            isDragHeader = NO;
        }
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self isLoading]) {
        return;
    }
    isDragging = NO;
    if (tailer.isLoading != YES && self.headerEnabled && scrollView.contentOffset.y <= CGRectGetMinY(header.frame)) {
        // Released above the header
        [self startPullLoading];
        tailer.hidden = YES;
    } else if (header.isLoading != YES && self.tailerEnabled && scrollView.contentOffset.y >= CGRectGetMaxY(tailer.frame) - CGRectGetHeight(self.frame)) {
        [self startPullLoading];
        header.hidden = YES;
    } else {
        [self pullCancelled];
    }
}

@end
