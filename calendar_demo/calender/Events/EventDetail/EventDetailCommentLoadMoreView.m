//
//  EventDetailCommentLoadMoreView.m
//  Calvin
//
//  Created by zyax86 on 10/19/13.
//  Copyright (c) 2013 fang xiang. All rights reserved.
//

#import "EventDetailCommentLoadMoreView.h"

@interface EventDetailCommentLoadMoreView()
{
    UIButton *btnLoadMore;
    UIActivityIndicatorView *indicator;
    UIView *maskView;
}

@end

@implementation EventDetailCommentLoadMoreView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    btnLoadMore = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLoadMore.frame = CGRectMake(0, 0, 304, 45);
    [btnLoadMore setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnLoadMore setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    btnLoadMore.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [btnLoadMore setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
    [self addSubview:btnLoadMore];
    [btnLoadMore addTarget:self action:@selector(btnLoadMoreClick:) forControlEvents:UIControlEventTouchUpInside];
    
    maskView = [[UIView alloc] initWithFrame:self.bounds];
    [maskView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:maskView];
    
    [self stopLoading];
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [indicator setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
    [self addSubview:indicator];
}

- (void)btnLoadMoreClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(loadMoreComment)]) {
        [self.delegate loadMoreComment];
        [self startLoading];
    }
}

- (void)startLoading
{
    [btnLoadMore setTitle:@"Loading..." forState:UIControlStateNormal];
    [indicator startAnimating];
    [maskView setAlpha:0.7f];
    [btnLoadMore setUserInteractionEnabled:NO];
}

- (void)stopLoading
{
    [btnLoadMore setTitle:@"Load More" forState:UIControlStateNormal];
    [indicator stopAnimating];
    [maskView setAlpha:0.0f];
    [btnLoadMore setUserInteractionEnabled:YES];
}



@end
