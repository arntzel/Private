//
//  AddEventInviteViewController.h
//  calender
//
//  Created by zyax86 on 13-7-6.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddEventInviteViewControllerDelegate <NSObject>

- (void)setInVitePeopleArray:(NSArray *)inviteArray;

@end

@interface AddEventInviteViewController : UIViewController
@property (nonatomic, assign) id<AddEventInviteViewControllerDelegate> delegate;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)Cancel:(id)sender;
- (IBAction)create:(id)sender;

@end
