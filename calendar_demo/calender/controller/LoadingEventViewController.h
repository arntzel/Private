//
//  LoadingEventViewController.h
//  Calvin
//
//  Created by fangxiang on 14-2-28.
//  Copyright (c) 2014年 Pencil Me, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingEventViewController : UIViewController


@property IBOutlet UIProgressView * progressView;

@property IBOutlet UIActivityIndicatorView * indicatorView;

@property IBOutlet UIImageView * loadingView;

@property IBOutlet UILabel * label;


@end
