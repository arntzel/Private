//
//  EventDetailHeader.h
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailHeader : UIView

@property (retain, nonatomic) IBOutlet UIImageView *headerView;
@property (retain, nonatomic) IBOutlet UIImageView *crossView;
@property (retain, nonatomic) IBOutlet UIImageView *tickView;

- (void)setTicked;
- (void)setCrossed;

@end
