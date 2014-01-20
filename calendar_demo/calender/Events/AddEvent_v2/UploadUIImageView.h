//
//  UploadUIImageView.h
//  Calvin
//
//  Created by fangxiang on 14-1-19.
//  Copyright (c) 2014年 Pencil Me, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadUIImageView : UIView

@property UIImageView * imagePickerView;
@property NSString * uploadImageUrl;

@property(assign)  UIViewController * controller;

@end
