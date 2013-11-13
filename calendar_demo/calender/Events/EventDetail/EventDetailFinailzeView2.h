
#import <UIKit/UIKit.h>

#import <OHAttributedLabel/NSAttributedString+Attributes.h>
#import <OHAttributedLabel/OHASBasicHTMLParser.h>
#import <OHAttributedLabel/OHASBasicMarkupParser.h>

@interface EventDetailFinailzeView2 : UIView

@property (retain, nonatomic) IBOutlet UILabel *eventTimeLabel;
@property (retain, nonatomic) IBOutlet UIView *contentView;

+(EventDetailFinailzeView2 *) creatView;

@end
