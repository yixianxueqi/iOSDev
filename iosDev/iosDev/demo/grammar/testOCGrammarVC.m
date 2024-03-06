//
//  testOCGrammarVC.m
//  iosDev
//
//  Created by kingdee on 2024/3/6.
//

#import "testOCGrammarVC.h"
#import "HHCommonModel.h"

@interface testOCGrammarVC ()

@end

@implementation testOCGrammarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"testOCGrammarVC";
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self setupData];
    [self setupView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self testSuper];
    [self testKindAndMember];
    [self testKeywordOBJC];
}


- (void)setupView {
    
}

- (void)setupData {
    
    
}

# pragma mark - private
- (void)testSuper {
    HHHotDog *hd = [[HHHotDog alloc] init];
    [hd testSelfSuper];
}

- (void)testKindAndMember {
    
    NSLog(@"NSObject isKindOf NSObject: %d", [[NSObject class] isKindOfClass:[NSObject class]]);
    NSLog(@"NSObject isMemeberOf NSObject: %d", [[NSObject class] isMemberOfClass:[NSObject class]]);
    NSLog(@"HHFood isKindOf HHFood: %d", [[HHFood class] isKindOfClass:[HHFood class]]);
    NSLog(@"HHFood isMemeberOf HHFood: %d", [[HHFood class] isMemberOfClass:[HHFood class]]);
}

- (void)testKeywordOBJC {
    
    // !!! 注意swift的debugPrint 和 NSLog一起打印时，在控制台输出并不是按照顺序的，可搜索找到
    
    /*
     1. swift类继承自NSObject，可以访问到类，但不能直接调用其方法, 需加@objc
     */
    Person *ps = [[Person alloc] init];
//    [ps sing];
    [ps talk];
    
    /*
     2. 加了@objcMembers, 类、扩展extension、子类的方法都可访问
     */
    [ps sing];
    [ps jump];
    Student *stu = [[Student alloc] init];
    [stu run];
    
}

@end
