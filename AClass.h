//
//  AClass.h
//  Blocks
//
//  Created by wangtao on 14-3-11.
//  Copyright (c) 2014年 wto. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef int (^ABlock)(int);

@interface AClass : NSObject

// 将retain修改成copy
@property (nonatomic, copy) ABlock ablock;
@property (nonatomic, assign) int bint;
@property (nonatomic, retain) NSMutableDictionary *cdict;

- (void)work1;
- (void)work2;
- (void)work3;

@end
