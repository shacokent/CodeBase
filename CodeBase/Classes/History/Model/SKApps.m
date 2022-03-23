//
//  SKApps.m
//  CodeBase
//
//  Created by hongchen li on 2021/12/30.
//  Copyright © 2021 shacokent. All rights reserved.
//

#import "SKApps.h"

@implementation SKApps

+(instancetype)appsWithDict:(NSDictionary*)dict{
    SKApps *skM = [[SKApps alloc] init];
    //字典的KEY和模型的属性一一对应时可以使用KVC的setValuesForKeysWithDictionary
//    否则使用
//    skM.name = dict[@"name"];
//    skM.icon = dict[@"icon"];
//    skM.download = dict[@"download"];
    [skM setValuesForKeysWithDictionary:dict];
    return skM;
}
@end
