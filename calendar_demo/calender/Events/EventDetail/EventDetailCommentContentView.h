//
//  EventDetailCommentContentView.h
//  detail
//
//  Created by zyax86 on 13-8-4.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Comment.h"

@interface EventDetailCommentContentView : UIView

- (id)init;

-(void) updateView:(User *) me andComments:(NSArray *) comments;

-(void) addComment:(Comment *) comment;


@end
