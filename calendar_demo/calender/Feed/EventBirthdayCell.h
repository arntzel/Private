//
//  EventBirthdayCell.h
//  Calvin
//
//  Created by Yevgeny on 3/22/14.
//  Copyright (c) 2014 Pencil Me, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@class FeedEventEntity;

@interface EventBirthdayCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UIView *separator;

-(void) refreshView:(FeedEventEntity *) event lastForThisDay:(BOOL)lastForThisDay;

@end
