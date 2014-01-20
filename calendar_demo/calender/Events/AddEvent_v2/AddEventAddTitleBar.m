#import "AddEventAddTitleBar.h"

@interface AddEventAddTitleBar()
{
    UILabel *labelTitle;
    UIButton *leftBtn;
    UIButton *rightBtn;
}

@end

@implementation AddEventAddTitleBar
@synthesize delegate;

- (void)dealloc
{
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUserInteractionEnabled:YES];
        //[self setBackgroundColor:[UIColor colorWithRed:45/255.0f green:172/255.0f blue:149/255.0f alpha:1.0f]];
        self.backgroundColor = [UIColor clearColor];
        
        labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
        [labelTitle setBackgroundColor:[UIColor clearColor]];
        
        labelTitle.textAlignment = NSTextAlignmentCenter;
        //自动折行设置
        labelTitle.lineBreakMode = NSLineBreakByWordWrapping;
        labelTitle.numberOfLines = 0;
        
        [self addSubview:labelTitle];
        labelTitle.text = @"NEW EVENT";
        [labelTitle setTextAlignment:NSTextAlignmentCenter];
        [labelTitle setTextColor:[UIColor whiteColor]];
        [labelTitle setFont:[UIFont boldSystemFontOfSize:14]];
        
        leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 20, 80, 44)];
        [leftBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        [leftBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [self addSubview:leftBtn];
        [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(320 - 80 - 8, 20, 80, 44)];
        [rightBtn setTitle:@"Save" forState:UIControlStateNormal];
        [rightBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [rightBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:rightBtn];
        [rightBtn addTarget:self action:@selector(rightBtnCick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (id)init
{
    return [self initWithFrame:CGRectMake(0, 0, 320, 64)];
}

- (void)setTitle:(NSString *)title
{
    [labelTitle setText:title];
}

- (void)setLeftBtnText:(NSString *)text
{
    [leftBtn setTitle:text forState:UIControlStateNormal];
}

- (void)setRightBtnText:(NSString *)text
{
    [rightBtn setTitle:text forState:UIControlStateNormal];
}

- (void) setRightBtnHidden:(BOOL) hidden;
{
    rightBtn.hidden = hidden;
}

-(void) setRightBtnEnable:(BOOL) enable
{
    rightBtn.enabled = enable;
}

- (void) setTitleHidden:(BOOL) hidden
{
    labelTitle.hidden = hidden;
}

- (void)leftBtnClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(leftNavBtnClick)]) {
        [self.delegate leftNavBtnClick];
    }
}

- (void)rightBtnCick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(rightNavBtnClick)]) {
        [self.delegate rightNavBtnClick];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
