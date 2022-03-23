//
//  NSDictionary+SKRuntimeKVC.m
//  CodeBase
//
//  Created by hongchen li on 2022/2/8.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "NSDictionary+SKRuntimeKVC.h"

@implementation NSDictionary (SKRuntimeKVC)

-(void)creatPropertyCode{
    NSMutableString *codes = [NSMutableString string];
    //遍历字典
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *code;
//        isKindOfClass判断是否是当前类或者子类
//        BOOL是NSNumber的子类，所以需要放在NSNumber之前，不然会误判
        if([obj isKindOfClass:NSClassFromString(@"__NSCFBoolean")]){
            //注意BOOL类型判断
            code = [NSString stringWithFormat:@"@property (nonatomic,assign) BOOL %@;",key];
        }else if([obj isKindOfClass:[NSString class]]){
            code = [NSString stringWithFormat:@"@property (nonatomic,strong) NSString *%@;",key];
        }else if([obj isKindOfClass:[NSNumber class]]){
            code = [NSString stringWithFormat:@"@property (nonatomic,assign) NSInteger %@;",key];
        }
        //....
        [codes appendFormat:@"\n%@\n",code];
    }];
    NSLog(@"codes---%@",codes);
}
@end
