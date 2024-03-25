//
//  HHCommonModel.m
//  iosDev
//
//  Created by kingdee on 2024/3/6.
//

#import "HHCommonModel.h"

@implementation HHFood

- (id)copyWithZone:(NSZone *)zone {
    HHFood *food = [[[self class] alloc] init];
    food.name = [self.name copy];
    return food;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    HHFood *food = [[[self class] alloc] init];
    food.name = [self.name mutableCopy];
    return food;
}

@end


@implementation HHHotDog

- (void)testSelfSuper {
    
    NSLog(@"self class: %@", [self class]);
    NSLog(@"super class: %@", [super class]);
    NSLog(@"self superclass: %@", [self superclass]);
    NSLog(@"super superclass: %@", [self superclass]);
}

@end
