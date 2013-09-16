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
}

@property(nonatomic,retain) NSArray *headers;
@property(nonatomic, retain) NSArray * statuses;

@end

@implementation EventDetailHeaderListView

- (id)initWithHeaderArray:(NSArray *)headerArray andStatusArray:(NSArray *) statusArray andCountLimit:(NSInteger)countLimit ShowArraw:(BOOL)arraw
{
    self = [super init];
    if (self) {
        self = [super initWithFrame:CGRectZero];
        limit = countLimit;
        self.headers = headerArray;
        self.statuses = statusArray;
        
        showMoreArraw = arraw;

        [self relayoutList];
    }
    return self;
}

-(void) dealloc
{
    self.statuses = nil;
    self.headers = nil;
    [super dealloc];
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
        
        NSObject * obj = [self.headers objectAtIndex:index];
        
        if( [obj isKindOfClass: [UIImage class]]) {
            UIImage * image = (UIImage*) obj;
            [header setHeader:image];
        } else {
            NSString * url = [self.headers objectAtIndex:index];
            [header setHeaderUrl:url];
        }
        
       
        if (self.statuses == nil) {
            [header setTickAndCrossHidden];
        }
        else
        {
            int status = [[self.statuses objectAtIndex:index] intValue];

            if(status == 1) {
                [header setTicked];
            } else {
                [header setCrossed];
            }
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
