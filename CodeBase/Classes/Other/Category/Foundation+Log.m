//
//  NSDictionary+Log.m
//  CodeBase
//
//  Created by hongchen li on 2022/1/20.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import <Foundation/Foundation.h>

@implementation NSDictionary (Log)
//重写系统方法descriptionWithLocale控制输出
-(NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level{
    NSMutableString *string = [NSMutableString string];
    [string appendString:@"{"];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [string appendFormat:@"%@:",key];
        [string appendFormat:@"%@,",obj];
    }];
    [string appendString:@"}"];
    //去掉最后一个逗号，搜索逗号位置,NSBackwardsSearch从后往前搜索，返回搜索到的第一个符号的位置
    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
    if(range.location != NSNotFound){
        [string deleteCharactersInRange:range];
    }
    return string;
}
@end

@implementation NSArray (Log)
//重写系统方法descriptionWithLocale控制输出
-(NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level{
    NSMutableString *string = [NSMutableString string];
    [string appendString:@"["];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [string appendFormat:@"%@,\n",obj];
    }];
    [string appendString:@"]"];
    //去掉最后一个逗号，搜索逗号位置,NSBackwardsSearch从后往前搜索，返回搜索到的第一个符号的位置
    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
    if(range.location != NSNotFound){
        [string deleteCharactersInRange:range];
    }
    return string;
}
@end
