//
//  EventDetailCommentView.m
//  detail
//
//  Created by zyax86 on 13-8-3.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDetailCommentView.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Utils.h"
#import "NSString+Hex.h"

@implementation EventDetailCommentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setHeaderPhoto:(UIImage *)photo
{
    [_commentAutherPhotoView setImage:photo];
}

-(void) setHeaderPhotoUrl:(NSString *) url
{
    NSString * headerUrl = url;
    
    if(headerUrl == nil) {
        _commentAutherPhotoView.image = [UIImage imageNamed:@"header.png"];
    } else {
        [_commentAutherPhotoView setImageWithURL:[NSURL URLWithString:headerUrl]
                         placeholderImage:[UIImage imageNamed:@"header.png"]];
    }
}

- (void)updateUI
{
    [_commentAutherPhotoView setClipsToBounds:YES];
    [_commentAutherPhotoView.layer setCornerRadius:_commentAutherPhotoView.frame.size.width / 2];
    
    [_commentAutherPhotoView.layer setShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.16f].CGColor];
    [_commentAutherPhotoView.layer setShadowRadius:3.0f];
    [_commentAutherPhotoView.layer setShadowOffset:CGSizeMake(0, 1.0f)];
    [_commentAutherPhotoView.layer setBorderColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f].CGColor];
    [_commentAutherPhotoView.layer setBorderWidth:1.0f];
    
}

-(void) updateView:(Comment *) cmt
{
    [self setHeaderPhotoUrl:cmt.commentor.avatar_url];
    self.commentContentLabel.text = cmt.msg;
    self.commentTimeLabel.text = [Utils getTimeText:cmt.createTime];
}

+(EventDetailCommentView *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventDetailCommentView" owner:self options:nil];
    EventDetailCommentView * view = (EventDetailCommentView*)[nibView objectAtIndex:0];
    [view updateUI];
    return view;
}

- (void)dealloc {
    [_commentAutherPhotoView release];
    [_commentContentLabel release];
    [_commentTimeLabel release];
    [super dealloc];
}
@end
