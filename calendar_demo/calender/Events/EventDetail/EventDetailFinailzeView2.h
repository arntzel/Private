
#import <UIKit/UIKit.h>

#import <OHAttributedLabel/NSAttributedString+Attributes.h>
#import <OHAttributedLabel/OHASBasicHTMLParser.h>
#import <OHAttributedLabel/OHASBasicMarkupParser.h>
#import <OHAttributedLabel/OHAttributedLabel.h>


@interface EventDetailFinailzeView2 : UIView

@property (retain, nonatomic) IBOutlet OHAttributedLabel *eventTimeLabel;
@property (retain, nonatomic) IBOutlet UIButton *eventTimeBtn;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *VoteStateBtn;
@property (weak, nonatomic) IBOutlet UILabel *cfmedLabel;

@property (weak, nonatomic) IBOutlet UILabel *declinesLabel;

@property (weak, nonatomic) IBOutlet UILabel *eventTypeLabel;
+(EventDetailFinailzeView2 *) creatView;

+(EventDetailFinailzeView2 *) creatViewWithStartDate:(NSDate *)date;

@end
