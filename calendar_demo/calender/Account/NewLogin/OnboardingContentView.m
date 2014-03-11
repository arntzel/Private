//
//  OnboardingContentView.m
//  Calvin
//
//  Created by Kevin Wu on 3/8/14.
//  Copyright (c) 2014 Pencil Me, Inc. All rights reserved.
//

#import "OnboardingContentView.h"
#import "ViewUtils.h"
#import "UIColor+Hex.h"

@implementation OnboardingContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void) awakeFromNib
{
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    //self.contentImage.contentMode = UIViewContentModeScaleAspectFit;
    self.title.textColor = [UIColor generateUIColorByHexString:@"#313534"];
    self.subTitle.textColor = [UIColor generateUIColorByHexString:@"#313534"];
}

+(OnboardingContentView *) create
{
    return (OnboardingContentView *)[ViewUtils createView:@"OnboardingContentView"];
}

-(void)setBackgroundImage:(UIImage *)image
{
    CGRect view1ImgFrame = self.contentImage.frame;
    view1ImgFrame.size.width = image.size.width;
    view1ImgFrame.size.height = image.size.height;
    self.contentImage.frame = view1ImgFrame;
    [self.contentImage setImage:image];
    //[self setNeedsDisplay];
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
