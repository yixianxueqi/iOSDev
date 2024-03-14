//
//  testBlockOCViewController.m
//  iosDev
//
//  Created by kingdee on 2024/3/14.
//

#import "testBlockOCViewController.h"

typedef void(^VoidBlock)(void);

@interface testBlockOCViewController ()

@property (nonatomic, copy) VoidBlock tempBlock1;

@end

@implementation testBlockOCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"testBlockOCVC";
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self setupData];
    [self setupView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self testBlockWeakStrong];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)setupView {
    
}

- (void)setupData {
    
    
}

# pragma mark - private

- (void)testBlockWeakStrong {
    /*
     测试block内的 弱引用 - 强引用 是否会影响对象的销毁时机；
     */
    WEAKSELF
    self.tempBlock1 = ^{
        STRONGSELF
        NSLog(@"testBlockWeakStrong block %@", strongSelf);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 会延迟销毁，等该段代码执行完毕后self才销毁
//            NSLog(@"testBlockWeakStrong delay strong %@", strongSelf);
            // 不会延迟销毁，代码会执行, waekSelf已经被销毁了
            NSLog(@"testBlockWeakStrong delay waek %@", weakSelf);
        });
    };
    self.tempBlock1();
}

@end
