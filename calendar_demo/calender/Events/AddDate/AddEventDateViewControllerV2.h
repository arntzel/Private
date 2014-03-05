//
//  AddEventDateViewControllerV2.h
//  Calvin
//
//  Created by fangxiang on 14-3-4.
//  Copyright (c) 2014年 Pencil Me, Inc. All rights reserved.
//

#import "BaseUIViewController.h"
#import "FeedEventTableView.h"
#import "AddEventDateViewController.h"

@interface AddEventDateViewControllerV2 : BaseUIViewController


@property(strong) IBOutlet UISegmentedControl * navigationSegment;


@property(strong) IBOutlet UIDatePicker * datePricker;

@property(strong) IBOutlet UIPickerView * allDayPricker;


@property(strong) IBOutlet UISwitch * allDaySwitch;

@property(strong) IBOutlet UIView * bottomView;


-(IBAction) btnCancelClicked:(id)sender;

-(IBAction) btnSaveClicked:(id)sender;

-(IBAction)segmentAction:(UISegmentedControl *)Seg;


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@property(strong) FeedEventTableView * tableView;

@property(nonatomic,assign) id<AddEventDateViewControllerDelegate> delegate;

- (id)initWithEventDate:(ProposeStart *)arrangedDate;


@end
