//
//  EventDetailCommentConformed.h
//  calender
//
//  Created by zyax86 on 8/25/13.
//  Copyright (c) 2013 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailCommentConformedView : UIView

@property (weak, nonatomic) IBOutlet UILabel *labConformTime;

- (void)setConformTimeString:(NSString *)conformTime;

+(EventDetailCommentConformedView *)creatView;
@end
