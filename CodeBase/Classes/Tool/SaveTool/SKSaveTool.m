//
//  SKSaveTool.m
//  CodeBase
//
//  Created by hongchen li on 2021/12/14.
//  Copyright © 2021 shacokent. All rights reserved.
//

#import "SKSaveTool.h"

@implementation SKSaveTool

+ (nullable id)objectForKey:(NSString*)defaulName{
   return [[NSUserDefaults standardUserDefaults] objectForKey:defaulName];
}

+ (void)setObject:(nullable id)value forKey:(NSString *)defaultName{
    //屏蔽传入的key==nil
    if(defaultName){
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
        //偏好会在不定时自动存储，所以设置一下立即存储
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
@end
