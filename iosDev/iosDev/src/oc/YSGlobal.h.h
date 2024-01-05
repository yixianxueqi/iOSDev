//
//  YSGlobal.h.h
//  iosDev
//
//  Created by kingdee on 2024/1/5.
//

#ifndef YSGlobal_h_h
#define YSGlobal_h_h

// 强弱引用
#define WEAKSELF __weak typeof(self) weakSelf = self;
#define STRONGSELF __strong typeof(weakSelf) strongSelf = weakSelf;

// 日志输出控制
#if DEBUG
    //
#else
    #define NSLog(...) do{} while(0)
#endif


#endif /* YSGlobal_h_h */
