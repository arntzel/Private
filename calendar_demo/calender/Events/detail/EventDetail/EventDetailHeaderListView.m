//
//  EventDetailHeaderListView.m
//  detail
//
//  Created by 张亚 on 13-8-17.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDetailHeaderListView.h"
#import "EventDetailHeader.h"

@interface EventDetailHeaderListView()
{
    NSInteger limit;
    
    BOOL showMoreArraw;
    BOOL showSelectedStatus;
}

@property(nonatomic,retain) NSArray *headers;

@end

@implementation EventDetailHeaderListView

- (id)initWithHeaderArray:(NSArray *)headerArray andCountLimit:(NSInteger)countLimit ShowArraw:(BOOL)arraw ShowSelectedStatu:(BOOL)selectedStatu
{
    self = [super init];
    if (self) {
        self = [super initWithFrame:CGRectZero];
        limit = countLimit;
        self.headers = headerArray;
        showMoreArraw = arraw;
        showSelectedStatus = selectedStatu;
        
        [self relayoutList];
    }
    return self;
}


- (void)relayoutList
{
    NSInteger index = 0;
    CGFloat gap = 4;
    CGRect viewFrame = CGRectZero;
    for (index = 0; index < [self.headers count]; index++) {
        if (index >= limit) {
            break;
        }
        if (index != 0) {
            viewFrame.size.width += gap;
        }
        
        EventDetailHeader *header = [EventDetailHeader creatView];
        UIImage *image = [self.headers objectAtIndex:index];
        [header setHeader:image];
        if (showSelectedStatus) {
            [header setTicked];
        }
        else
        {
            [header setTickAndCrossHidden];
        }
        
        [header updateUI];
        [self addSubview:header];
        
        CGRect headerFrame = header.frame;
        headerFrame.origin.x = viewFrame.size.width;
        [header setFrame:headerFrame];
        
        viewFrame.size.width += header.frame.size.width;
        viewFrame.size.height = header.frame.size.height;
    }
    
    if (showMoreArraw) {
        if (index >= limit) {
            viewFrame.size.width += gap;
            UIImage *arrawImage = [UIImage imageNamed:@"event_detail_header_list_arraw.png"];
            UIImageView *arrawView = [[UIImageView alloc] initWithImage:arrawImage];
            [arrawView setFrame:CGRectMake(viewFrame.size.width, (viewFrame.size.height - arrawImage.size.height / 2) / 2, arrawImage.size.width / 2, arrawImage.size.height / 2)];
            [self addSubview:arrawView];
            [arrawView release];
            viewFrame.size.width += arrawView.frame.size.width;
        }
    }

    
    self.frame = viewFrame;
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
