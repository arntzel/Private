//
//  FeedEventTableViewCell.m
//  Calvin
//
//  Created by Kevin Wu on 1/2/14.
//  Copyright (c) 2014 fang xiang. All rights reserved.
//

#import "FeedEventTableViewCell.h"
#import "UIColor+Hex.h"

@implementation FeedEventTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];
}

//-(void)drawRect000:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
//    CGContextFillRect(context, rect);
//    
//    CGContextSetStrokeColorWithColor(context, [UIColor generateUIColorByHexString:@"#d1d9d2"].CGColor);
//    CGContextStrokeRect(context, CGRectMake(50, rect.size.height, rect.size.width - 50, 1));
//}

@end
