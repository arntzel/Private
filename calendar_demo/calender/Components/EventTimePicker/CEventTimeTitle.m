#import "CEventTimeTitle.h"
#import <QuartzCore/QuartzCore.h>
#import "AttributedLabel.h"
#import "CEventTimePicker.h"
#import "EventTimePickerDefine.h"
#import "KalDate.h"
#import "CTimePicker.h"


@interface CEventTimeTitle()

@property (weak, nonatomic) IBOutlet UIView *monthDayView;
@property (weak, nonatomic) IBOutlet UILabel *dateTypeLable;
@property (weak, nonatomic) IBOutlet AttributedLabel *duringTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end


@implementation CEventTimeTitle
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)awakeFromNib
{
    [self setBackgroundColor:[UIColor colorWithRed:233/255.0f green:240/255.0f blue:234/255.0f alpha:1.0f]];
    
    [self.monthDayView setBackgroundColor:[UIColor colorWithRed:53/255.0f green:162/255.0f blue:144/255.0f alpha:1.0f]];
    [self.monthDayView.layer setCornerRadius:self.monthDayView.frame.size.height / 2];

    self.dateTypeLable.textColor = [UIColor colorWithRed:73/255.0f green:73/255.0f blue:73/255.0f alpha:1.0f];
    
    self.duringTimeLabel.textColor = [UIColor colorWithRed:73/255.0f green:73/255.0f blue:73/255.0f alpha:1.0f];

    
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapTimeView:)];
    [self addGestureRecognizer:gesture];
    
    [self.deleteBtn addTarget:self action:@selector(onDetelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) onDetelBtnClick:(id)sender
{
    [self.delegate didDeleteTime:self];
}

- (void)setTime:(ProposeStart *)startTime
{

    NSDate *startDate = [startTime.start copy];

    NSString *type = [CEventTimePicker getStartTypeFromePropseType:startTime];
    self.dateTypeLable.text = type;
    if ([type isEqualToString:DATE_TYPE_ALL_DAY])
    {
        //all day
        [self.dateTypeLable setFrame:CGRectMake(52, 3, 248, self.frame.size.height - 6)];
        [self.dateTypeLable setFont:[UIFont systemFontOfSize:13]];
        [self.duringTimeLabel setHidden:YES];
    }
    else
    {
        [self.dateTypeLable setFrame:CGRectMake(52, 3, 248, 21)];
        [self.dateTypeLable setFont:[UIFont systemFontOfSize:12]];
        [self.duringTimeLabel setHidden:NO];
        
        
        NSString *fullString = @"";
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *parts = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:startDate];
        
        NSInteger hour = 0;
        NSInteger ampmMark = 0;
        if (parts.hour == 0) {
            hour = 12;
            ampmMark = 0;
        }
        else if (parts.hour == 12)
        {
            hour = 12;
            ampmMark = 1;
        }
        else
        {
            hour = parts.hour % 12;
            ampmMark = parts.hour / 12;
        }
        
        NSString *timeStr = @"";
        timeStr = [timeStr stringByAppendingString:[NSString stringWithFormat:@"%d", hour]];
        timeStr = [timeStr stringByAppendingString:@":"];
        timeStr = [timeStr stringByAppendingString:[NSString stringWithFormat:@"%02d", parts.minute]];
        NSString *ampm = [[CTimePicker ampmArray] objectAtIndex:ampmMark];
        
        
        if ([type isEqualToString:DATE_TYPE_EXACTLY_AT])
        {
            //exact at
            ampm = [ampm stringByAppendingString:@" ends "];

            NSDate *endDate = [startTime.end copy];
            parts = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:endDate];

            NSInteger endHour = 0;
            NSInteger endAmpm = 0;
            if (parts.hour == 0) {
                endHour = 12;
                endAmpm = 0;
            }
            else if (parts.hour == 12)
            {
                endHour = 12;
                endAmpm = 1;
            }
            else
            {
                endHour = parts.hour % 12;
                endAmpm = parts.hour / 12;
            }
            
            NSString *endTimeStr = @"";
            endTimeStr = [endTimeStr stringByAppendingString:[NSString stringWithFormat:@"%d", endHour]];
            endTimeStr = [endTimeStr stringByAppendingString:@":"];
            endTimeStr = [endTimeStr stringByAppendingString:[NSString stringWithFormat:@"%02d", parts.minute]];
            NSString *endAmpmStr = [[CTimePicker ampmArray] objectAtIndex:endAmpm];
            
            KalDate *kalDate = [KalDate dateFromNSDate:endDate];
            NSInteger month = [kalDate month] - 1;
            NSInteger day = [kalDate day];
            NSString *monthStr = [[CTimePicker monthNameArray] objectAtIndex:month];
            monthStr = [monthStr stringByAppendingString:@" "];
            NSString *dayStr = [NSString stringWithFormat:@"%d ", day];
            
            fullString = [NSString stringWithFormat:@"%@%@%@%@%@%@",timeStr, ampm, monthStr, dayStr, endTimeStr, endAmpmStr];
            self.duringTimeLabel.text = fullString;
            
            NSInteger seekPointPre = 0;
            NSInteger seekPointNex = timeStr.length;
            [self.duringTimeLabel setFont:[UIFont systemFontOfSize:16] fromIndex:seekPointPre length:seekPointNex];
            seekPointPre += seekPointNex;
            seekPointNex = ampm.length;
            [self.duringTimeLabel setFont:[UIFont systemFontOfSize:11] fromIndex:seekPointPre length:seekPointNex];
            seekPointPre += seekPointNex;
            seekPointNex = monthStr.length;
            [self.duringTimeLabel setFont:[UIFont systemFontOfSize:11] fromIndex:seekPointPre length:seekPointNex];
            seekPointPre += seekPointNex;
            seekPointNex = dayStr.length;
            [self.duringTimeLabel setFont:[UIFont systemFontOfSize:16] fromIndex:seekPointPre length:seekPointNex];
            seekPointPre += seekPointNex;
            seekPointNex = endTimeStr.length;
            [self.duringTimeLabel setFont:[UIFont systemFontOfSize:16] fromIndex:seekPointPre length:seekPointNex];
            seekPointPre += seekPointNex;
            seekPointNex = endAmpmStr.length;
            [self.duringTimeLabel setFont:[UIFont systemFontOfSize:11] fromIndex:seekPointPre length:seekPointNex];

        }
        else
        {
            //duration
            ampm = [ampm stringByAppendingString:@" for "];
            
            NSString *duringHourStr = [NSString stringWithFormat:@"%d", startTime.duration_hours];
            NSString *hourUnit = @" hours";
            NSString *duringMinStr = [NSString stringWithFormat:@"%02d", startTime.duration_minutes];
            NSString *miniteUnit = @" minites";
            
            if (startTime.duration_hours == 0) {
                duringHourStr = @"";
                hourUnit = @"";
            }
            if (startTime.duration_minutes == 0) {
                duringMinStr = @"";
                miniteUnit = @"";
            }
            
            fullString = [NSString stringWithFormat:@"%@%@%@%@%@%@",timeStr, ampm, duringHourStr,hourUnit, duringMinStr, miniteUnit];
            self.duringTimeLabel.text = fullString;
            
            NSInteger seekPointPre = 0;
            NSInteger seekPointNex = timeStr.length;
            [self.duringTimeLabel setFont:[UIFont systemFontOfSize:16] fromIndex:seekPointPre length:seekPointNex];
            seekPointPre += seekPointNex;
            seekPointNex = ampm.length;
            [self.duringTimeLabel setFont:[UIFont systemFontOfSize:11] fromIndex:seekPointPre length:seekPointNex];
            seekPointPre += seekPointNex;
            seekPointNex = duringHourStr.length;
            [self.duringTimeLabel setFont:[UIFont systemFontOfSize:16] fromIndex:seekPointPre length:seekPointNex];
            seekPointPre += seekPointNex;
            seekPointNex = hourUnit.length;
            [self.duringTimeLabel setFont:[UIFont systemFontOfSize:11] fromIndex:seekPointPre length:seekPointNex];
            seekPointPre += seekPointNex;
            seekPointNex = duringMinStr.length;
            [self.duringTimeLabel setFont:[UIFont systemFontOfSize:16] fromIndex:seekPointPre length:seekPointNex];
            seekPointPre += seekPointNex;
            seekPointNex = miniteUnit.length;
            [self.duringTimeLabel setFont:[UIFont systemFontOfSize:11] fromIndex:seekPointPre length:seekPointNex];
        }
    }
    
    KalDate *kalDate = [KalDate dateFromNSDate:startDate];
    NSInteger month = [kalDate month] - 1;
    NSInteger day = [kalDate day];
    
    NSString *monthStr = [[CTimePicker monthNameArray] objectAtIndex:month];
    self.monthLabel.text = monthStr;
    self.dayLabel.text = [NSString stringWithFormat:@"%d", day];

    [self.duringTimeLabel setColor:[UIColor colorWithRed:73/255.0f green:73/255.0f blue:73/255.0f alpha:1.0f] fromIndex:0 length:self.duringTimeLabel.text.length];
}

-(void) singleTapTimeView:(UITapGestureRecognizer*) tap
{
    if ([self.delegate respondsToSelector:@selector(didTapdView:)]) {
        [self.delegate didTapdView:self];
    }
}

@end