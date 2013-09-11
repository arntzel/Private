#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>

@interface AttributedLabel : UILabel{
    NSMutableAttributedString          *_attString;
}

- (void)setColor:(UIColor *)color fromIndex:(NSInteger)location length:(NSInteger)length;

- (void)setFont:(UIFont *)font fromIndex:(NSInteger)location length:(NSInteger)length;

- (void)setStyle:(CTUnderlineStyle)style fromIndex:(NSInteger)location length:(NSInteger)length;

@end
