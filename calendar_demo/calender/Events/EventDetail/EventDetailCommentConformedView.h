//
//  EventDetailCommentConformed.h
//  calender
//
//  Created by zyax86 on 8/25/13.
//  Copyright (c) 2013 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailCommentConformedView : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *labConformTime;
@property (retain, nonatomic) IBOutlet UILabel *labMsg;

- (void)setConformTimeString:(NSString *)conformTime;

+(EventDetailCommentConformedView *)creatView;
@end
