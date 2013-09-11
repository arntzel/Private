//
//  EventDetailCommentView.h
//  detail
//
//  Created by zyax86 on 13-8-3.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailCommentView : UIView

+(EventDetailCommentView *) creatView;
@property (retain, nonatomic) IBOutlet UIImageView *commentAutherPhotoView;
@property (retain, nonatomic) IBOutlet UILabel *commentContentLabel;
@property (retain, nonatomic) IBOutlet UILabel *commentTimeLabel;

- (void)setHeaderPhoto:(UIImage *)photo;
-(void) setHeaderPhotoUrl:(NSString *) url;

@end
