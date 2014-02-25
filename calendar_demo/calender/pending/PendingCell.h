//
//  PendingCell.h
//  Calvin
//
//  Created by Yevgeny on 2/25/14.
//  Copyright (c) 2014 Pencil Me, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FeedEventEntity;

@interface PendingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *actionText;
@property (weak, nonatomic) IBOutlet UIView *separator;

-(void) refreshView:(FeedEventEntity *) event lastForThisDay:(BOOL)lastForThisDay;

@end
