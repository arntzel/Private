//
//  ExtendArray.h
//  Calvin
//
//  Created by zyax86 on 10/11/13.
//  Copyright (c) 2013 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExtendArray : NSObject
@property(nonatomic) NSInteger tag;

- (id)objectAtIndex:(NSUInteger)index;
- (void)addObject:(id)object;
- (NSUInteger)count;

+ (ExtendArray *)array;
@end
