//
//  testQueueOCViewController.m
//  iosDev
//
//  Created by kingdee on 2024/3/14.
//

#import "testQueueOCViewController.h"

@interface testQueueOCViewController ()

@end

@implementation testQueueOCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"testQueueOCVC";
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self setupData];
    [self setupView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self testQueueHasCreateThread];
}


- (void)setupView {
    
}

- (void)setupData {
    
    
}

# pragma mark - private
- (void)testQueueHasCreateThread {
    /*
     测试队列是否开启了线程:
     1. 同步队列，都不开启新线程，都是在当前线程内执行；
     2. 异步队列，开启了新线程；
     */
    NSLog(@"%@", [NSThread mainThread]);
    
    // 同步
    dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", 0);
    dispatch_sync(serialQueue, ^{
        sleep(1.0);
        NSLog(@"serialQueue sync: %@", [NSThread currentThread]);
    });
    
    dispatch_queue_t conQueue = dispatch_queue_create("conQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(conQueue, ^{
        sleep(1.0);
        NSLog(@"conQueue sync: %@", [NSThread currentThread]);
    });
    
    // 异步
    dispatch_async(serialQueue, ^{
        sleep(1.0);
        NSLog(@"serialQueue async: %@", [NSThread currentThread]);
    });
    
    dispatch_async(conQueue, ^{
        sleep(1.0);
        NSLog(@"conQueue async: %@", [NSThread currentThread]);
    });
    
}

@end
