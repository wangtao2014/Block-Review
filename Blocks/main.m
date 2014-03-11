//
//  main.m
//  Blocks
//
//  Created by wangtao on 14-3-7.
//  Copyright (c) 2014年 wto. All rights reserved.
//  http://blog.csdn.net/kesalin/article/details/8870578
//  http://www.cnbluebox.com/?p=255

#import <Foundation/Foundation.h>

// This always works. The stack for exampleA doesn’t go away until after the block has finished executing. So whether the block is allocated on the stack or the heap, it will be valid when it is executed.
void exampleA() {
    char a = 'A';
    ^{
        printf("%c\n", a);
    }();
}

// Without ARC, the block is an NSStackBlock allocated on the stack of exampleB_addBlockToArray. By the time it executes in exampleB, the block is no longer valid, because that stack has been cleared.With ARC, the block is properly allocated on the heap as an autoreleased NSMallocBlock to begin with
void exampleB_addBlockToArray(NSMutableArray *array) {
    // without ARC,下面这种情况不可以运行 报EXC_BAD_ACCESS错误
//    char b = 'B';
//    [array addObject:^{
//        printf("%c\n", b);
//    }];
    // without ARC, 可以使用下面的方法 是将NSStackBlock force it to be copied to the heap as an NSMallocBlock
    
    char b = 'B';
    void (^block)() = ^{
         printf("%c\n", b);
    };
    block = [[block copy] autorelease];
    [array addObject:block];
}

void exampleB() {
    NSMutableArray *array = [NSMutableArray array];
    exampleB_addBlockToArray(array);
    void (^block)() = [array objectAtIndex:0];
    block();
}

// always works .Since the block doesn’t capture any variables in its closure, it doesn’t need any state set up at runtime. it gets compiled as an NSGlobalBlock. It’s neither on the stack nor the heap, but part of the code segment, like any C function. This works both with and without ARC.

void exampleC_addBlockToArray(NSMutableArray *array) {
    [array addObject:^{
        printf("C\n");
    }];
}

void exampleC() {
    NSMutableArray *array = [NSMutableArray array];
    exampleC_addBlockToArray(array);
    void (^block)() = [array objectAtIndex:0];
    block();
}

// This is similar to example B. Without ARC, the block would be created on the stack of exampleD_getBlock and then immediately become invalid when that function returns. However, in this case, the error is so obvious that the compiler will fail to compile, with the error error: returning block that lives on the local stack. With ARC, the block is correctly placed on the heap as an autoreleased NSMallocBlock.

typedef void (^dBlock)();

dBlock exampleD_getBlock() {
    char d = 'D';
    void (^block)() = ^{
        printf("%c\n", d);
    };
    return [[block copy] autorelease];
}

void exampleD() {
    exampleD_getBlock()();
}

// This is just like example D, except that the compiler doesn’t recognize it as an error, so this code compiles and crashes. Even worse, this particular example happens to work fine if you disable optimizations. So watch out for this working while testing and failing in production. With ARC, the block is correctly placed on the heap as an autoreleased NSMallocBlock.
typedef void (^eBlock)();

eBlock exampleE_getBlock() {
    char e = 'E';
    void (^block)() = ^{
        printf("%c\n", e);
    };
    return block;
}

void exampleE() {
    eBlock block = exampleE_getBlock();
    block();
}

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
    }
    return 0;
}

