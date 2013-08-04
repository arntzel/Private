//
//  EventDetailPhotoView.h
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EventDetailPhotoView : UIView
@property (retain, nonatomic) IBOutlet UIImageView *photoView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;

+(EventDetailPhotoView *) creatView;
@end
