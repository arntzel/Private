//
//  ExtendArray.m
//  Calvin
//
//  Created by zyax86 on 10/11/13.
//  Copyright (c) 2013 fang xiang. All rights reserved.
//

#import "ExtendArray.h"

@interface ExtendArray()
@property(nonatomic, strong) NSMutableArray *array;
@end

@implementation ExtendArray
@synthesize array;

- (id)init
{
    self = [super init];
    if (self) {
        self.array = [NSMutableArray array];
    }
    return self;
}

- (id)objectAtIndex:(NSUInteger)index
{
    return [self.array objectAtIndex:index];
}

- (void)addObject:(id)object
{
    [self.array addObject:object];
}

- (NSUInteger)count
{
    return [self.array count];
}

- (void)addObjectFromArray:(NSArray *)array_
{
    [self.array addObjectsFromArray:array_];
}

+ (ExtendArray *)array
{
    return [[ExtendArray alloc] init];
}

@end
