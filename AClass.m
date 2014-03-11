//
//  AClass.m
//  Blocks
//
//  Created by wangtao on 14-3-11.
//  Copyright (c) 2014年 wto. All rights reserved.
//

#import "AClass.h"

@implementation AClass

@synthesize ablock;
@synthesize bint;

- (id)init
{
    self = [super init];
    self.ablock = ^(int aint){
        return aint + self.bint;
    };
    
    self.bint = 10;
    self.cdict = [[NSMutableDictionary alloc] init];
    return self;
}

- (void)work1
{
    __block int x = 10;
    __block NSString *y = @"test";
    dispatch_async(dispatch_get_main_queue(), ^{
        x = 20;
        y = @"demo";
    });
}


- (void)work2
{
    NSMutableArray *z = @[@"test"];
    dispatch_async(dispatch_get_main_queue(), ^{
        z[1] = @"demo";
    });
}

- (void)work3
{
    dispatch_async(dispatch_get_main_queue(), ^{
       self.cdict[@"1"] = @"test";
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _cdict[@"2"] = @"test";
    });
    
    NSMutableDictionary *newDic = self.cdict;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        newDic[@"3"] = @"test";
    });
    NSLog(@"%@", self.cdict);
}

- (void)dealloc
{
    self.cdict = nil;
    [super dealloc];
}

@end
