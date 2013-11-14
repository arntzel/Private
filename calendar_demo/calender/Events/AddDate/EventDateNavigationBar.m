//
//  EventDateNavigationBar.m
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDateNavigationBar.h"
#import <OHAttributedLabel/NSAttributedString+Attributes.h>
#import <OHAttributedLabel/OHASBasicHTMLParser.h>
#import <OHAttributedLabel/OHASBasicMarkupParser.h>
#import <OHAttributedLabel/OHAttributedLabel.h>

@interface EventDateNavigationBar()

@property (retain, nonatomic) IBOutlet UIButton *leftBtn;

@property (weak, nonatomic) IBOutlet OHAttributedLabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end


@implementation EventDateNavigationBar
@synthesize delegate;

- (IBAction)leftBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(leftBtnPress:)]) {
        [self.delegate leftBtnPress:sender];
    }
}

- (void)awakeFromNib
{
    [self setBackgroundColor:[UIColor clearColor]];
    [self.bgView setBackgroundColor:[UIColor clearColor]];
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
    
    self.titleLabel.attributedText = [OHASBasicHTMLParser attributedStringByProcessingMarkupInAttributedString:self.titleLabel.attributedText];
    self.titleLabel.centerVertically = YES;
}

- (void)setDescription:(NSString *)description
{
    self.descriptionLabel.text = description;
}

+(EventDateNavigationBar *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventDateNavigationBar" owner:self options:nil];
    EventDateNavigationBar * view = (EventDateNavigationBar*)[nibView objectAtIndex:0];
    
    return view;
}

@end
