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
    [self testNameSpace];
    [self testCopy];
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

- (void)testNameSpace {
    /*
     oc与swift混编：命名空间的问题；
     swift 访问 oc 没问题；
     oc 访问 swift 存在命名空间问题；
        1. 添加命名空间，nameSpace.clss
        2. 重命名 Teacher -> @objc(HHTeacher) -> HHTeacher, @objc前提条件，需继承自NSObject
     
     swift访问swift存在命名空间问题：
        1. 添加命名空间, 例：Alamofire.RetryPolicy
        2. 重命名 Teacher -> @objc(HHTeacher) -> HHTeacher, @objc前提条件，需继承自NSObject
     */
//    Class cls = NSClassFromString(@"Person"); // nil
    NSString *nameSpace = [NSBundle mainBundle].infoDictionary[@"CFBundleName"];
    NSString *clsStr = [[NSString alloc] initWithFormat:@"%@.Person", nameSpace];
    Class cls = NSClassFromString(clsStr); // Person class
    NSLog(@"person class: %d", [[[Person alloc] init] isKindOfClass:cls]);
    
    Class cls2 = NSClassFromString(@"HHTeacher");
    NSLog(@"HHTeacher class: %d", [[[HHTeacher alloc] init] isKindOfClass:cls2]);
    
    
//    let cls = NSClassFromString("MASViewAttribute")
//    debugPrint("cls: \(cls)")
//    let cls2 = NSClassFromString("Alamofire.RetryPolicy")
//    debugPrint("cls2: \(cls2), \(RetryPolicy.self)")
}

- (void)testCopy {
    
    /*
     1. NSObject内有方法：
     - (id)copy;
     - (id)mutableCopy;
     但是未实现，自定义子类直接使用会崩溃。
     -[HHFood copyWithZone:]: unrecognized selector sent to instance
     
     2. 需子类实现协议 <NSCopying, NSMutableCopying>
     本质是实现方法：
     - (id)copyWithZone:(NSZone *)zone
     - (id)mutableCopyWithZone:(NSZone *)zone
     */
    HHFood *food = [[HHFood alloc] init];
    food.name = @"food";
    NSLog(@"ori: %@", food);
    HHFood *foodc = [food copy];
    NSLog(@"copy: %@", foodc);
    HHFood *foodmc = [food mutableCopy];
    NSLog(@"mutableCopy: %@", foodmc);
}

@end
