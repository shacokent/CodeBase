//
//  SKApps.h
//  CodeBase
//
//  Created by hongchen li on 2021/12/30.
//  Copyright © 2021 shacokent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKApps : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *icon;
@property (nonatomic,strong) NSString *download;
+(instancetype)appsWithDict:(NSDictionary*)dict;

@end

NS_ASSUME_NONNULL_END
