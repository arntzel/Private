//
//  ContactViewCell.h
//  Calvin
//
//  Created by fangxiang on 14-1-18.
//  Copyright (c) 2014年 Pencil Me, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@interface ContactViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView * peopleHeader;
@property (retain, nonatomic) IBOutlet UILabel * peopleName;
@property (retain, nonatomic) IBOutlet UILabel * peopleEmail;


- (void) refreshView: (Contact*) user;

- (void) refreshView: (NSString *) name andEmal:(NSString *)  email;

- (void)setHeaderImageUrl:(NSString *)url;

@end
