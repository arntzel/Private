//
//  PedingEventViewControllerNew.h
//  Calvin
//
//  Created by Yevgeny on 2/23/14.
//  Copyright (c) 2014 Pencil Me, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseMenuViewController.h"
#import "CoreDataModel.h"

@interface PedingEventViewControllerNew : BaseMenuViewController <CoreDataModelDelegate>

@property(assign) id<PopDelegate> popDelegate;


- (void)loadData;

@end
