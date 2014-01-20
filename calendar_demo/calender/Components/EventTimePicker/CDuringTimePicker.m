
#import "CDuringTimePicker.h"
#import "CLoopPickerView.h"
#import "CPickerView.h"
#import "CPickerCell.h"
#import "PickerViewProtocal.h"

@interface CDuringTimePicker()<CPickerViewProtocol>
{
    CLoopPickerView *duringPicker;
    NSInteger currentMinites;
}



@end

@implementation CDuringTimePicker
@synthesize delegate;

- (void)dealloc
{
    duringPicker.delegate = nil;
}

- (id)init
{
    return [self initWithFrame:CGRectMake(0, 0, 320, CellHeight * 5)];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initPicker:frame];
    }
    return self;
}

- (void)initPicker:(CGRect)frame
{
    duringPicker = [[CLoopPickerView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self addSubview:duringPicker];
    duringPicker.delegate = self;
    [duringPicker setTextAlignment:NSTextAlignmentCenter];
    [duringPicker reloadData];
    [duringPicker scrollToIndex:0 WithAnimation:NO];
}

- (void)setDuringTime:(NSInteger)duringTime_
{
    currentMinites = duringTime_;
    if (duringTime_ <= 0) {
        return;
    }
    NSInteger currentIndex = (duringTime_ / 15) - 1;
    if (duringTime_ <= 0) {
        currentIndex = 0;
    }
    [duringPicker scrollToIndex:currentIndex WithAnimation:NO];
}

- (void)Picker:(id<CPickerViewInterface>)picker didSelectRowAtIndex:(NSInteger)index
{
    currentMinites = (index + 1) * 15;
    if ([self.delegate respondsToSelector:@selector(DuringTimePicker:didChooseMinites:)]) {
        [self.delegate DuringTimePicker:self didChooseMinites:currentMinites];
    }
}

- (NSInteger)numberOfRowsInPicker:(id<CPickerViewInterface>)picker
{
    return 12 * 4 ;//12 hours，4 quart per hour
}

- (NSString *)stringOfRowsInPicker:(id<CPickerViewInterface>)picker AtIndex:(NSInteger)index
{
    return [CDuringTimePicker getFormatTimeForMinites:(index + 1) * 15];
}

- (NSInteger)getCurrentDuringMinites
{
    return currentMinites;
}

+ (NSString *)getFormatTimeForMinites:(NSInteger)minites_
{
    NSInteger hour = minites_ / 60;
    NSInteger minites = minites_ % 60;
    NSString *duringTimeString = @"";
    if (hour > 0) {
        duringTimeString = [duringTimeString stringByAppendingString:[NSString stringWithFormat:@"%d hour ", hour]];
    }
    if (minites > 0) {
        duringTimeString = [duringTimeString stringByAppendingString:[NSString stringWithFormat:@"%d minutes", minites]];
    }
    
    return duringTimeString;
}

- (NSString *)getCurrentFormatTime
{
    return [CDuringTimePicker getFormatTimeForMinites:currentMinites];
}

@end
