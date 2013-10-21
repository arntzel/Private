//
//  EventDetailCommentLoadMoreView.h
//  Calvin
//
//  Created by zyax86 on 10/19/13.
//  Copyright (c) 2013 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EventDetailCommentLoadMoreViewDelegate <NSObject>

- (void)loadMoreComment;

@end

@interface EventDetailCommentLoadMoreView : UIView

@property(nonatomic,weak) id<EventDetailCommentLoadMoreViewDelegate> delegate;

- (void)startLoading;
- (void)stopLoading;

@end
