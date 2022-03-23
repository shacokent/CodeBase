//
//  SKThreeVC.m
//  CodeBase
//
//  Created by hongchen li on 2022/2/9.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKThreeVC.h"

@interface SKThreeVC ()

@end

@implementation SKThreeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [self decryptDic:@"4MzcmxcxczzccnIXdddxIMxOkGkUxvzcmzbxUdU4MzcmxcxczzccnUxsczscUandxzbxmdzUNIBIMEIPqPKtwIPqPxIxOdOaUytPyqLoM.Y.cdm9Us"];
}

-(NSMutableDictionary*)buildDic{
    //原始字符串
    NSString* str=@"1234567890qwertyuiopasdfghjklzxcvbnm._+-QWERTYUIOPASDFGHJKLZXCVBNM";
    //原始字符串对应字典
    NSString* dic=@"zxcvbnmasdfghjklqwertyuiopASDFGHJKLPOIUYTREWQZXCVBNM0987654321-_+.";
    NSMutableDictionary * dicMap=[[NSMutableDictionary alloc]init];
    for(int i=0;i<str.length;i++){
        [dicMap setValue:[NSString stringWithFormat:@"%C",[dic  characterAtIndex:i]] forKey:[NSString stringWithFormat:@"%C",[str characterAtIndex:i]]];
    }
    NSLog(@"dicMap---%@",dicMap);
    return dicMap;
}

//加密
-(NSString*)encryptDic:(NSString*)word{
    NSMutableDictionary * dic=[self buildDic];
    NSString *sb=@"";
    for(int i=0;i<word.length;i++){
        NSString* ch=[NSString stringWithFormat:@"%C",[word characterAtIndex:i]];
        sb=[sb stringByAppendingFormat:@"%@",[dic objectForKey:ch]];
    }
    return sb;
}
//解密
-(NSString*)decryptDic:(NSString*)word{
    NSMutableDictionary * dic=[self buildDic];
    NSString *sb=@"";
    for(int i=0;i<word.length;i++){
        NSString* ch=[NSString stringWithFormat:@"%C",[word characterAtIndex:i]];
        for(NSString *line in [dic allKeys]){
            if([[dic objectForKey:line] isEqualToString:ch]){
                sb=[sb stringByAppendingFormat:@"%@",line];
            }
        }
    }
    NSLog(@"%@",sb);
    return sb;
}

@end
