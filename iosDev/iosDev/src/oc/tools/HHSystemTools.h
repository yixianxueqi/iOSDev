//
//  HHSystemTools.h
//  iosDev
//
//  Created by kingdee on 2024/2/22.
//

#import <Foundation/Foundation.h>

/*
 禁止调试程序；
 return: 1:调试模式,退出程序, 0:非调试模式,不作任何事情;
 */
int anti_debug(void);

NS_ASSUME_NONNULL_BEGIN

@interface HHSystemTools : NSObject

// 禁止在release模式下进行调试
+ (void)forbiddenReleaseTypeDebugMode;

@end

NS_ASSUME_NONNULL_END
