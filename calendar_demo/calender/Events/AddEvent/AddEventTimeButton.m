//
//  AddEventTimeButton.m
//  Calvin
//
//  Created by xiangfang on 13-9-28.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "AddEventTimeButton.h"
#import "ViewUtils.h"
@implementation AddEventTimeButton

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
    UIImage *bgImage = [UIImage imageNamed:@"addEventBtnBg.png"];
    bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    //[self.btn setImage:bgImage forState:UIControlStateNormal];
    [self.btn setBackgroundImage:bgImage forState:UIControlStateNormal];
}

+(AddEventTimeButton *) create
{
    return (AddEventTimeButton *)[ViewUtils createView:@"AddEventTimeButton"];
}

@end
