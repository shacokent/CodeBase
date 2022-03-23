//
//  SKNSOperation.m
//  CodeBase
//
//  Created by hongchen li on 2021/12/30.
//  Copyright © 2021 shacokent. All rights reserved.
//

#import "SKNSOperation.h"

@implementation SKNSOperation

//告知执行的任务
-(void)main{
    NSLog(@"%@",[NSThread currentThread]);
    
    //耗时操作
    for(NSInteger i = 0;i < 1000 ; i++){
        NSLog(@"%@",[NSThread currentThread]);
    }
//    取消操作，苹果官方建议，在耗时循环操作后添加取消
    if(self.isCancelled) return;
    
    for(NSInteger i = 0;i < 1000 ; i++){
        NSLog(@"%@",[NSThread currentThread]);
    }
    
    if(self.isCancelled) return;
    
    for(NSInteger i = 0;i < 1000 ; i++){
        NSLog(@"%@",[NSThread currentThread]);
    }
}

@end
