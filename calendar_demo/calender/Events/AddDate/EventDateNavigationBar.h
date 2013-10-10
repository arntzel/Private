//
//  EventDetailNavigationBar.h
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EventDateNavigationBarDelegate <NSObject>

- (void)leftBtnPress:(id)sender;

@end

@interface EventDateNavigationBar : UIView
@property(nonatomic,assign) id<EventDateNavigationBarDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;


- (IBAction)leftBtnClick:(id)sender;

- (void)setTitle:(NSString *)title;
- (void)setDescription:(NSString *)description;

+(EventDateNavigationBar *) creatView;
@end
