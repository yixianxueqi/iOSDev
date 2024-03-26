//
//  HHVideoCompreeeTools.h
//  iosDev
//
//  Created by kingdee on 2024/3/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHVideoCompreeeTools : NSObject

- (void)compreessVideoWithInputURL:(NSURL*)inputURL
                         outputURL:(NSURL*)outputURL
                          duration:(CGFloat)duration
                         comletion:(void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
