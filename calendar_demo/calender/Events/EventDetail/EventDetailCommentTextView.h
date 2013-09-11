//
//  EventDetailCommentTextView.h
//  calender
//
//  Created by zyax86 on 8/25/13.
//  Copyright (c) 2013 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailCommentTextView : UIView

@property (retain, nonatomic) IBOutlet UIImageView *autherPhotoView;
@property (retain, nonatomic) IBOutlet UITextField * messageField;

- (void)setHeaderPhoto:(UIImage *)photo;

-(void) setHeaderPhotoUrl:(NSString *) url;

+(EventDetailCommentTextView *)creatView;

@end
