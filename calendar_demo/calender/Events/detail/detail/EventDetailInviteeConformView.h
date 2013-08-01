//
//  EventDetailInviteeView.h
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailInviteeConformView : UIView

@property (retain, nonatomic) IBOutlet UIButton *tickedBtn;
@property (retain, nonatomic) IBOutlet UIButton *crossedbtn;

- (IBAction)tickBtnClick:(id)sender;
- (IBAction)crossBtnClick:(id)sender;

- (void)setTicked;
- (void)setCrossed;
@end
