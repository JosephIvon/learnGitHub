//
//  FWBAppsViewController.m
//  CellImageDownload
//
//  Created by fanwenbo on 16/5/16.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#define  FWBAppImageFile(url)  [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[url lastPathComponent]]

#import "FWBAppsViewController.h"
#import "FWBAppsModel.h"
#import "FWBDownloadOperation.h"

@interface FWBAppsViewController () <FWBDownloadOperationDelegate>
/**
 *  所有的应用数据
 */
@property(nonatomic,strong) NSMutableArray * apps;

/**
 *  存放所有下载操作的队列
 */
@property(nonatomic,strong) NSOperationQueue * queue;

/**
 *  存放所有的下载操作（url作为key，operation对象是value）
 */
@property(nonatomic,strong) NSMutableDictionary * operations;

/**
 *  存放所有下载完成的图片
 */
@property(nonatomic,strong) NSMutableDictionary * images;

@end

@implementation FWBAppsViewController

#pragma mark -- lazy load
-(NSMutableDictionary *)images{
    if (!_images) {
        _images = [[NSMutableDictionary alloc] init];
    }
    return _images;
}

-(NSMutableDictionary *)operations{
    if (!_operations) {
        _operations = [[NSMutableDictionary alloc] init];
    }
    return _operations;
}

-(NSOperationQueue *)queue{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

-(NSMutableArray *)apps{
    if (!_apps) {
        NSMutableArray * appsArray = [NSMutableArray array];
        //加载plist
        NSString * file = [[NSBundle mainBundle] pathForResource:@"apps" ofType:@"plist"];
        NSArray * dictArr = [NSArray arrayWithContentsOfFile:file];
        
        //字典转模型
        for (NSDictionary * subDic in dictArr) {
            FWBAppsModel * app = [FWBAppsModel appWithDict:subDic];
            [appsArray addObject:app];
        }
        //赋值
        self.apps = appsArray;
    }
    return _apps;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    //移除所有下载操作
    [self.queue cancelAllOperations];
    [self.operations removeAllObjects];
    //移除所有的图片缓存
    [self.images removeAllObjects];
}

// 当用户准备开始拖拽表格的时候 暂停下载队列
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //暂停下载
    [self.queue setSuspended:YES];
}

// 当用户停止拖拽的的时候 恢复下载队列
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //恢复下载
    [self.queue setSuspended:NO];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.apps.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * reuserID = @"app";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuserID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuserID];
    }
    //取出模型
    FWBAppsModel * model = self.apps[indexPath.row];
    
    //设置基本信息
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.download;
    
    //先从images缓存中取出图片url对应的image
    UIImage * image = self.images[model.icon];
    if (image) {//图片已经成功下载过（有缓存）
        cell.imageView.image = image;
    }
    else{ //图片并未成功下载过（没有缓存）
        //获取caches路径，拼接文件路径
        NSString * file = FWBAppImageFile(model.icon);
        
        NSLog(@"%@",file);
        
        //先从沙盒中取出图片
        NSData * data = [NSData dataWithContentsOfFile:file];
        
        if (data) {
            cell.imageView.image = [UIImage imageWithData:data];
        }else{
            //显示占位图片
            cell.imageView.image = [UIImage imageNamed:@"placeholder"];
            
            //下载图片
            [self download:model.icon indexPath:indexPath];
        }
    }
    return cell;
}

// 直接在主线程中调用模型的url数据并对cell的image进行赋值
- (void)basicDownloadImages {
    //    // 设置cell的图片
    //    /**
    //     这样写的确可以从远程下载图片并将图片显示在cell上 但有缺陷
    //     1. 下载的工作是在主线程中进行，会阻塞主线程进行工作  -> 影响用户体验 (卡)
    //     2. 重复下载 (该方法在tableView滚动的时候就会调用)  -> 浪费流量/浪费时间/影响性能
    //     */
    //    NSURL *url = [NSURL URLWithString:model.icon]; // 从模型中取出url
    //    NSData *data = [NSData dataWithContentsOfURL:url];
    //    cell.imageView.image = [UIImage imageWithData:data];
}

/**
 缺点：
 异步下载图片，cell会在图片下载完成前先行返回，再次滚动tableView的时候会刷新图片
 还是会重复刷新图片
 */
- (void)downloadImageWithBasicQueue {
    //    // 设置cell的图片 (使用NSBlockOperation)
    //    // 需要保证每张图片仅下载一次
    //    // -> 解决：使用字典，使一个url对应一个operation
    //    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
    //        NSURL *url = [NSURL URLWithString:app.icon]; // 从模型中取出url
    //        NSData *data = [NSData dataWithContentsOfURL:url]; // 转化为data
    //
    //        // 回到主线程进行显示
    //        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    //            cell.imageView.image = [UIImage imageWithData:data];
    //        }];
    //
    //    }];
    //    // 将操作添加进队列
    //    [self.queue addOperation:op];
}

- (void)downloadImagesForOnetime {
#pragma mark 下载并显示cell对应的图片
    // 需求：1.不可重复下载(每张图片仅下载1次)
    /**
     设置cell的图片 (使用NSBlockOperation)
     需要保证每张图片仅下载一次
     -> 解决：使用字典，使一个url对应一个operation
     */
    
    // 取出当前图片的url对应的下载操作 (operation 操作)
    // 代码运行到底部时，所有的图片的下载操作已经保存进了字典
    // 字典对应的key value 第一次加载时，这两个属性都不存在，加进字典后，这些对象都为存在
    // 当再次滚动tableView调用这个方法来到下面的代码的时候，会从字典中直接取出对应的值 ---> 不会重复下载
    
    //    NSBlockOperation *op = self.operations[app.icon];
    //    // 如果操作为空(此时的确为空) 为其赋值
    //    if (op == nil) {
    //        op = [NSBlockOperation blockOperationWithBlock:^{
    //            NSURL *url = [NSURL URLWithString:app.icon]; // 从模型中取出url
    //            NSData *data = [NSData dataWithContentsOfURL:url]; // 转化为data
    //            UIImage *image = [UIImage imageWithData:data]; // (转化为image也是耗时操作，所以放在子线程)
    //
    //            // 回到主线程进行显示
    //            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    //                cell.imageView.image = image; // 设置图片
    //
    //                // 存放图片到images字典中
    //                self.images[app.icon] = image;
    //
    //                // 从字典中移除下载操作
    //                // 1. 为了防止下载失败时 程序运行到此处直接跳过
    //                // 2. 防止字典过大
    //                [self.operations removeObjectForKey:app.icon];
    //            }];
    //        }];
    //
    //        // 监听下载完毕
    //
    //        // 将操作添加进队列
    //        [self.queue addOperation:op];
    //        
    //        // 添加到字典中
    //        self.operations[app.icon] = op;
    //    }
    //
}

// 将下载图片的相关操作抽取出来，方法的设定上根据需要创建两个接口填入数据
- (void)download:(NSString *)imageUrl indexPath:(NSIndexPath *)indexPath {
    // 开始下载图片 (此时再执行判断下载图片的操作是否完成的代码)
//    NSBlockOperation *op = self.operations[imageUrl];
    FWBDownloadOperation * op = self.operations[imageUrl];
    // 如果操作为空(此时的确为空) 为其赋值
    if (op) return;
    
    //创建操作，下载图片
    op = [[FWBDownloadOperation alloc] init];
    op.imageUrl = imageUrl;
    op.indexPath = indexPath;
    
    //设置代理
    op.delegate = self;
    
//    // 使用__weak 解决block 中关于循环引用的问题 (使用一个弱指针的控制器代替所有的self.xxx 操作)
//    // __weak AppsViewController *appsVc = self;
//    __weak typeof(self) appsVc = self; // 上一句的另一种写法 (更简洁，适用性更高 typeof(self) 可以自动判断当前self类型 )
//    
//    op = [NSBlockOperation blockOperationWithBlock:^{
//        NSURL *url = [NSURL URLWithString:imageUrl]; // 从模型中取出url
//        NSData *data = [NSData dataWithContentsOfURL:url]; // 转化为data
//        UIImage *image = [UIImage imageWithData:data]; // (转化为image也是耗时操作，所以放在子线程)
//        
//        // 回到主线程进行显示
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            // 直接设置cell图片会有隐患 因为可重用cell的关系,显示的可能不是需要的图片
//            // 解决: 图片下载完毕后应该刷新那行对应的cell而不是之前内存地址对应的cell --> 刷新表格即可
//            // cell.imageView.image = image; // 设置图片
//            
//            /**
//             存放图片到images字典中
//             self.images[app.icon] = image;
//             如果图片为nil 即字典的value为nil ---> 报错
//             解决方法: 再嵌套一个if判断语句
//             */
//            if (image) { // 只有image有值的时候才会将图片添加进字典
//                appsVc.images[imageUrl] = image;
//                
//#warning 将图片存入沙盒
//                //UIImage -> NSData -> file
//                NSData * data = UIImagePNGRepresentation(image);
//                
//                //获取caches路径
////                NSString * caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//                //拼接文件路径
////                NSString * fileName = [imageUrl lastPathComponent];
////                NSString * file = [caches stringByAppendingPathComponent:fileName];
//                
//                //图片存到沙盒中
//                [data writeToFile:FWBAppImageFile(imageUrl) atomically:YES];
//            }
//            
//            // 从字典中移除下载操作
//            // 1. 为了防止下载失败时 程序运行到此处直接跳过
//            // 2. 防止字典过大
//            [appsVc.operations removeObjectForKey:imageUrl];
//            
//            // 刷新表格 使图片对应每一行的cell
//            // [self.tableView reloadData]; // 直接reloadData太消耗性能
//            [appsVc.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//        }];
//    }];

    // 将操作添加进队列
    [self.queue addOperation:op];
    
    // 添加到字典中 --> 加入字典可以阻止重复下载
    self.operations[imageUrl] = op;
    // [self.operations setObject:op forKey:app.icon]; 等价与该行代码
}

#pragma mark -- downloadImage Delegate
-(void)downloadOperation:(FWBDownloadOperation *)operation didFinishDownload:(UIImage *)image{
    if (image) {
        self.images[operation.imageUrl] = image;

#warning 将图片存入沙盒
        //UIImage -> NSData -> file
        NSData * data = UIImagePNGRepresentation(image);

        //图片存到沙盒中
        [data writeToFile:FWBAppImageFile(operation.imageUrl) atomically:YES];
    }

    [self.operations removeObjectForKey:operation.imageUrl];
    [self.tableView reloadRowsAtIndexPaths:@[operation.indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

/** 图片只下载一次的具体思路
 1. 每个cell的图片都有一个对应的url (保存在plist文件中)
 2. 检查该url的下载操作是否存在 : if(op == nil) 如果不存在/从未下载过 -> 将该操作放入一个blockOperation中 添加进队列 异步执行
 3. 将已经发生过的下载操作包装成value 保存到字典当中
 4. 当tableView再次滚动的时候 再次进入该方法 遇到  NSBlockOperation *op = self.operations[app.icon]; 语句。 此时可以从字典中取出对应操作 (op不为nil)
 不会再次创建新的下载操作
 * 一个url 对应一个 operation ---> 图片只下载一次达成
 */


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
