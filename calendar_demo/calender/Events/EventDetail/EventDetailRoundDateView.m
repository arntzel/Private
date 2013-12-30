//
//  EventDetailRoundDateView.m
//  Calvin
//
//  Created by Kevin Wu on 12/23/13.
//  Copyright (c) 2013 fang xiang. All rights reserved.
//

#import "EventDetailRoundDateView.h"
#import "KalDate.h"
#import "Utils.h"

const CGSize kDateViewSize = { 40.0f, 40.0f };

@implementation EventDetailRoundDateView
@synthesize date;
- (id)initWithFrame:(CGRect)frame withDate:(NSDate *)theDate;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.date = [Utils convertLocalDate:theDate];
        self.clipsToBounds = YES;
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(void)updateDateText
{
    KalDate *kalDate = [KalDate dateFromNSDate:date];
    NSString *monthText = [Utils formateMonthOnly:date];
    unsigned int day = [kalDate day];
    UIColor *textColor = [UIColor whiteColor];
    
    
    //draw day
    
    CGFloat fontSize = 17.f;
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize];
    // UIFont *font = [UIFont systemFontOfSize:fontSize];
    //UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
    
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    CGContextSelectFont(ctx, [font.fontName cStringUsingEncoding:NSUTF8StringEncoding], fontSize, kCGEncodingMacRoman);
    CGContextTranslateCTM(ctx, 0, kDateViewSize.height);
    CGContextScaleCTM(ctx, 1, -1);
    
    NSUInteger n = [kalDate day];
    NSString *dayText = [NSString stringWithFormat:@"%lu", (unsigned long)day];
    const char *dayStr = [dayText cStringUsingEncoding:NSUTF8StringEncoding];
    CGSize textSize = [dayText sizeWithFont:font];
    CGFloat textX, textY;
    
    textX = roundf(0.5f * (kDateViewSize.width - textSize.width)) +6;
    textY = 0.0f;
    [textColor setFill];
    CGContextShowTextAtPoint(ctx, textX, textY, dayStr, n >= 10 ? 2 : 1);
    
    
    //draw month
    CGFloat fontMonthSize = 12.f;
    UIFont *fontMonth = [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize];
    // UIFont *font = [UIFont systemFontOfSize:fontSize];
    //UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
    
    CGContextSelectFont(ctx, [fontMonth.fontName cStringUsingEncoding:NSUTF8StringEncoding], fontMonthSize, kCGEncodingMacRoman);
    //CGContextTranslateCTM(ctx, 0, kDateViewSize.height);
    //CGContextScaleCTM(ctx, 1, -1);
    
    const char *monthStr = [monthText cStringUsingEncoding:NSUTF8StringEncoding];
    textSize = [monthText sizeWithFont:fontMonth];
    
    textX = roundf(0.5f * (kDateViewSize.width - textSize.width)) +11;
    textY = 17;
    [textColor setFill];
    CGContextShowTextAtPoint(ctx, textX, textY, monthStr, 3);
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(ctx, 53.0/255.0f, 162.0/255.0f, 144.0/255.0f, 1);
    CGContextFillEllipseInRect(ctx, CGRectMake(6, 9, 40, 40));
    
    if (self.date) {
        [self updateDateText];
    }
}


@end
