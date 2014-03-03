//
//  EventDetailCommentView.h
//  detail
//
//  Created by zyax86 on 13-8-3.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@interface EventDetailCommentView : UITableViewCell

+(EventDetailCommentView *) creatView;
@property (retain, nonatomic) IBOutlet UIImageView *commentAutherPhotoView;
@property (strong, nonatomic) IBOutlet UIImageView *bubleBackground;
@property (retain, nonatomic) IBOutlet UILabel *commentContentLabel;
@property (retain, nonatomic) IBOutlet UILabel *commentTimeLabel;
@property (retain, nonatomic) IBOutlet UIView *commentContainer;


- (void)setHeaderPhoto:(UIImage *)photo;
-(void) setHeaderPhotoUrl:(NSString *) url;

-(void) updateView:(Comment *) cmt;

@end
