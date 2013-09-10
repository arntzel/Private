//
//  EventDetailNavigationBar.h
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EventDetailNavigationBarDelegate <NSObject>

- (void)leftBtnPress:(id)sender;
- (void)rightBtnPress:(id)sender;

@end

@interface EventDetailNavigationBar : UIView
@property(nonatomic,assign) id<EventDetailNavigationBarDelegate> delegate;

@property (retain, nonatomic) IBOutlet UIButton *leftBtn;
@property (retain, nonatomic) IBOutlet UIButton *rightbtn;

- (IBAction)leftBtnClick:(id)sender;
- (IBAction)rightBtnClick:(id)sender;

+(EventDetailNavigationBar *) creatView;
@end
