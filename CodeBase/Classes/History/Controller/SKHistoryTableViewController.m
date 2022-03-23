//
//  SKHistoryTableViewController.m
//  CodeBase
//
//  Created by hongchen li on 2021/12/8.
//  Copyright © 2021 shacokent. All rights reserved.
//

#import "SKHistoryTableViewController.h"
#import "SKApps.h"
#import "UIImageView+WebCache.h"

//枚举
//第一种写法,一个参数可以传递一个值
typedef enum{
    SKTypeTop,
    SKTypeBottom,
}SKType;

//第二种写法,定义类型,一个参数可以传递一个值
typedef NS_ENUM(NSInteger,SKType2) {
    SKTypeTop2,
    SKTypeBottom2,
};

//第三种写法，位移枚举，按位与，按位或，一个参数可以传递多个值
//如果是位移枚举，观察第一个枚举值，如果该值!=0 那么可以默认传0做参数，如果传0做参数那么效率最高
typedef NS_OPTIONS(NSInteger, SKType3){
    SKTypeTop3 = 1<<0,//1左移0位==1,1*2^0=1
    SKTypeBottom3 = 1<<1,//1左移1位==2,1*2^1=2
    SKTypeLeft3 = 1<<2,//1左移2位==4，1*2^2=4
    SKTypeRight3 = 1<<3,//1左移3位==8,1*2^3=8
};
//位移枚举方法调用，以及实现
//调用
//[self enumDemo:SKTypeTop3|SKTypeLeft3];
//实现
//按位与，只要有0则为0
//按位或，只要有1则为1
//-(void)enumDemo:(SKType3)type{
//    if(type & SKTypeTop3){
//        NSLog(@"SKTypeTop3");
//    }
//    if(type & SKTypeBottom3){
//        NSLog(@"SKTypeBottom3");
//    }
//    if(type & SKTypeLeft3){
//        NSLog(@"SKTypeLeft3");
//    }
//    if(type & SKTypeRight3){
//        NSLog(@"SKTypeRight3");
//    }
//}

@interface SKHistoryTableViewController ()
@property (nonatomic,strong) NSArray *apps;
@property (nonatomic,strong) NSMutableDictionary *images;
//采用NSCache
@property (nonatomic,strong) NSCache *images2;
@property (nonatomic,strong) NSOperationQueue *queue;
@property (nonatomic,strong) NSMutableDictionary *opertions;
@end

@implementation SKHistoryTableViewController

- (NSCache *)images2{
    if(_images2 == nil){
        _images2 = [[NSCache alloc] init];
        _images2.countLimit = 10;//设置最多缓存个数
    }
    return _images2;
}

- (NSMutableDictionary *)opertions{
    if(_opertions == nil){
        _opertions = [NSMutableDictionary dictionary];
    }
    return _opertions;
}

- (NSOperationQueue *)queue{
    if(_queue == nil){
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 5;
    }
    return _queue;
}

- (NSMutableDictionary *)images{
    if(_images == nil){
        _images = [NSMutableDictionary dictionary];
    }
    return _images;
}

- (NSArray *)apps{
    if(_apps == nil){
        //字典数组
        NSArray * arrayM = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"apps.plist" ofType:nil]];
        //转换成模型数组
        NSMutableArray *arrM = [NSMutableArray array];
        for(NSDictionary *dict in arrayM){
            [arrM addObject:[SKApps appsWithDict:dict]];
        }
        _apps = arrM;
    }
    return _apps;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.apps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //创建cell
    static NSString *cid = @"history";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cid];
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle     reuseIdentifier:cid];
    }
    SKApps *appM = self.apps[indexPath.row];
    cell.textLabel.text = appM.name;
    cell.detailTextLabel.text = appM.download;
    
    //下载图片，
//    1.注意（引入第三方框架SDWebImage）,但是加载的图片会非常小，需要自定义cell,在layoutSubviews中将imageview.frame写死大小
        /*
         第一个参数:下载图片的url地址
         第二个参数:占位图片
         */
        //[cell.imageView sd_setImageWithURL:[NSURL URLWithString:appM.icon] placeholderImage:[UIImage imageNamed:@"Snip20160221_306"]];
        
        /*
         第一个参数:下载图片的url地址
         第二个参数:占位图片
         第三个参数:缓存策略，0是默认方法
         第四个参数:progress 进度回调
            receivedSize:已经下载的数据大小
            expectedSize:要下载图片的总大小
         第五个参数:
            image:要下载的图片
            error:错误信息
            cacheType:缓存类型
            imageURL:图片url
         */
//        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:appM.icon] placeholderImage:[UIImage imageNamed:@"Snip20160221_306"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//            NSLog(@"%f",1.0 * receivedSize / expectedSize);
//
//        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            NSLog(@"%zd",cacheType);
//        }];
//    2.自己写
    //检测内存缓存是否有图片，如果没有，在检测沙盒缓存是否有图片，如果没有开启多线程下载，检测当前cell 下载操作是否存在，不存在，创建操作
//    UIImage * image = [self.images objectForKey:appM.icon];
    //采用NSCache
    UIImage * image = [self.images2 objectForKey:appM.icon];
    if(image){
        cell.imageView.image = image;
    }
    else{
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fileName = [appM.icon lastPathComponent];
        NSString * fullPath = [caches stringByAppendingPathComponent:fileName];
//        NSLog(@"fullPath---%@",fullPath);
        NSData * imageData = [NSData dataWithContentsOfFile:fullPath];
        if(imageData){
            image = [UIImage imageWithData:imageData];
            cell.imageView.image = image;
            //存入字典，内存缓存
//            [self.images setObject:image forKey:appM.icon];
            //采用NSCache
            [self.images2 setObject:image forKey:appM.icon];
        }
        else{
            NSBlockOperation *download = [self.opertions objectForKey:appM.icon];
            if(download){
                
            }
            else{
                //避免tableviewcell的重复利用导致的数据错乱问题，一般用占位图片
                cell.imageView.image = nil;
//                cell.imageView.image = [UIImage imageNamed:@"占位图片"];
                //开启线程下载,解决UI卡顿问题
                download = [NSBlockOperation blockOperationWithBlock:^{
                    
                    NSURL *url = [NSURL URLWithString:appM.icon];
                    NSData * imageData = [NSData dataWithContentsOfURL:url];
                    UIImage *image = [UIImage imageWithData:imageData];
                    
//                    容错处理,避免URL错误或其他原因导致image为空
                    if(image == nil){
                        //下载后移出操作缓存
                        [self.opertions removeObjectForKey:appM.icon];
                        return;
                    }
                    //存入字典，内存缓存，防止图片重复下载
//                    [self.images setObject:image forKey:appM.icon];
                    //采用NSCache
                    [self.images2 setObject:image forKey:appM.icon];
                    //沙盒缓存,选择cache，防止重新打开软件时候的图片的重复下载
                    //documents:会备份，缓存数据春入其中，APP商店不允许
                    //Libary:两个字目录preference，cache
                        //preference：偏好设置，保存账号
                        //cache：缓存文件
                    //tmp:临时路径，随时会被删除
                    [imageData writeToFile:fullPath atomically:YES];
                    //回到主线程更新UI，设置图片
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        cell.imageView.image = image;
                        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }];
                    
                    //下载后移出操作缓存
                    [self.opertions removeObjectForKey:appM.icon];
                }];
                
                //避免图片因网速问题滑动tableview后图片重复下载，建立操作缓存
                //添加操作到缓存中
                [self.opertions setObject:download forKey:appM.icon];
                
                [self.queue addOperation:download];
            }
            
        }
    }

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

//内存警告处理
-(void)didReceiveMemoryWarning{
    //清空内存缓存
//    [self.images removeAllObjects];
    //采用NSCache
    [self.images2 removeAllObjects];
    //清除队列中所有的操作
    [self.queue cancelAllOperations];
}
@end
