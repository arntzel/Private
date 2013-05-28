//
//  AddLocationViewController.h
//  calender
//
//  Created by zyax86 on 13-5-26.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddLocationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISearchBar *locationSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *txtSearchTabView;
@property (weak, nonatomic) IBOutlet UITableView *nearBySearchTabView;

@end
