//
//  ViewController.m
//  NSInvocationOperation
//
//  Created by fanwenbo on 16/5/15.
//  Copyright © 2016年 fanwenbo. All rights reserved.
//

#import "ViewController.h"

#define kImageUrl1  @"http://b.hiphotos.baidu.com/imgad/pic/item/902397dda144ad34f0a00f8bd7a20cf431ad859b.jpg"
#define kImageUrl2  @"http://h.hiphotos.baidu.com/image/h%3D200/sign=5a38b03bf5deb48fe469a6dec01e3aef/c9fcc3cec3fdfc033587c9e2d23f8794a5c226e8.jpg"
#define kImageUrl3  @"http://c.hiphotos.baidu.com/image/h%3D200/sign=db6598f3af014c08063b2fa53a7a025b/023b5bb5c9ea15ce0492f553b0003af33a87b26f.jpg"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self operation1];
//    [self operation2];
//    [self operation3];
    [self dependency];
}

-(void)dependency{
    /**
     假设有A、B、C三个操作，要求：
     1. 3个操作都异步执行
     2. 操作C依赖于操作B
     3. 操作B依赖于操作A
     */
    // 1.创建一个队列（非主队列）
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 2.创建3个操作
    NSBlockOperation *operationA = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"A1---%@", [NSThread currentThread]);
    }];
    [operationA addExecutionBlock:^{
        NSLog(@"A2---%@", [NSThread currentThread]);
    }];
    //A操作完成后调用
    [operationA setCompletionBlock:^{
        NSLog(@"afterOperationA---%@", [NSThread currentThread]);
    }];

    NSBlockOperation *operationB = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"B---%@", [NSThread currentThread]);
    }];
    NSBlockOperation *operationC = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"C---%@", [NSThread currentThread]);
    }];
    
    // 设置依赖(两个任务不能互相依赖)
    [operationB addDependency:operationA];
    [operationC addDependency:operationB];

    // 3.添加操作到队列中（自动异步执行任务）
    [queue addOperation:operationC];
    [queue addOperation:operationA];
    [queue addOperation:operationB];
}

-(void)operation3{
    //创建一个队列（并发队列）
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    
    //设置最大并发数
    queue.maxConcurrentOperationCount = 2;
    
    NSBlockOperation * operation1 = [NSBlockOperation blockOperationWithBlock:^{
        [self download:@{@"1":kImageUrl1,@"2":kImageUrl2,@"3":kImageUrl3}];
    }];
    NSBlockOperation * operation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"operation2---1---%@",[NSThread currentThread]);
    }];
    [operation2 addExecutionBlock:^{
        NSLog(@"operation2---2---%@",[NSThread currentThread]);
    }];
    NSBlockOperation * operation3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"operation3---%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation * operation4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"operation4---%@",[NSThread currentThread]);
    }];
    //添加操作到队列中，自动异步执行
    [queue addOperation:operation1];
    [queue addOperations:@[operation2,operation3,operation4] waitUntilFinished:NO];
    [queue addOperationWithBlock:^{
        NSLog(@"operation5---%@",[NSThread currentThread]);
    }];
    [queue addOperationWithBlock:^{
        NSLog(@"operation6---%@",[NSThread currentThread]);
    }];
    [queue addOperationWithBlock:^{
        NSLog(@"operation7---%@",[NSThread currentThread]);
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    //    [queue cancelAllOperations]; // 取消队列中的所有任务（不可恢复）
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //    [queue setSuspended:YES]; // 暂停队列中的所有任务
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //    [queue setSuspended:NO]; // 恢复队列中的所有任务
}

-(void)operation2{
    //任务数>1,才会开始异步执行
    NSBlockOperation * operation = [NSBlockOperation blockOperationWithBlock:^{
        [self download:@{@"1":kImageUrl1}];
    }];
    [operation addExecutionBlock:^{
        [self download:@{@"2":kImageUrl2}];
    }];
    [operation addExecutionBlock:^{
        [self download:@{@"3":kImageUrl3}];
    }];
    [operation start];
}

-(void)operation1{
    //创建队列
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    
    //创建操作
    NSInvocationOperation * operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(download:) object:@{@"1":kImageUrl1}];
    operation.name = @"下载图片";
    //直接调用start,在当前线程中同步执行
//       [operation start];
    
    //添加操作到队列中，自动异步执行
    [queue addOperation:operation];
}

-(void)download:(NSDictionary*)dict{
    NSLog(@"download ---- %@",[NSThread currentThread]);
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:obj]];
        UIImage * image = [UIImage imageWithData:data];
        switch ([key intValue]) {
            case 1:
                [self.imageView1 performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
                break;
            case 2:
                {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        self.imageView2.image = image;
                    }];
                }
                break;
            case 3:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.imageView3.image = image;
                    });
                }
                break;
            default:
                break;
        }
    }];
    
}

@end
