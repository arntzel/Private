//
//  EventDetailCommentTextView.h
//  calender
//
//  Created by zyax86 on 8/25/13.
//  Copyright (c) 2013 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailCommentTextView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *autherPhotoView;

- (void)setHeaderPhoto:(UIImage *)photo;

+(EventDetailCommentTextView *)creatView;

@end
