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
    [self testChangeFrame];
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

- (void)testChangeFrame {
    
    /*
     swift可以直接赋值
     */
//    let tempView = UIView()
//    tempView.frame = CGRect(x: 10.0, y: 20.0, width: 30.0, height: 40.0)
//    tempView.frame.origin.x = 15.0
//    debugPrint("\(tempView.frame)")
    
    /*
     oc不能直接赋值；
     tempView.frame.origin.x = 15.0;  >> Expression is not assignable
     解释：
     [[self image] frame].origin.x = 20;
     而Objective-C只是对C语言的一个扩展，所以，上面这句话会被转成C语言的函数调用形式，类似于这种形式：
     getframe().origin.x = 20;
     而在C语言里，函数的返回值是一个R-Value，是不能直接给它赋值的（所谓的R-Value，就是只能出现在等号的右边，你可以理解成是一个常量；
     而可以被赋值的是L-Value，可以出现在等号的左边，通常是变量）。因此，当你打算直接给函数的返回值赋值的时候，编译器告诉你"这个表达式无法被赋值"。这就是这个错误的出现原因。
     总结：
     作为对象属性的结构体不能直接修改该结构体的属性，只能整体修改该结构体；
     独立的结构体可以直接修改该结构体的属性。
     */
    UIView *tempView = [[UIView alloc] init];
    tempView.frame = CGRectMake(10.0, 20.0, 30.0, 40.0);
//    tempView.frame.origin.x = 15.0;
    CGRect frame = tempView.frame;
    frame.origin.x = 15.0;
    tempView.frame = frame;
    NSLog(@"%@", NSStringFromCGRect(tempView.frame));
    
}

@end
