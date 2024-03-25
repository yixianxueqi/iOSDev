//
//  HHCommonModel.h
//  iosDev
//
//  Created by kingdee on 2024/3/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHFood : NSObject <NSCopying, NSMutableCopying>
@property (nonatomic, strong) NSString *name;

@end

@interface HHHotDog : HHFood

- (void)testSelfSuper;

@end

NS_ASSUME_NONNULL_END
