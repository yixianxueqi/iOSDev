//
//  HHGlobal.h.h
//  iosDev
//
//  Created by kingdee on 2024/1/5.
//

#ifndef HHGlobal_h_h
#define HHGlobal_h_h

// 强弱引用
#define WEAKSELF __weak typeof(self) weakSelf = self;
#define STRONGSELF __strong typeof(weakSelf) strongSelf = weakSelf;

// 日志输出控制
#if DEBUG
    //
#else
    #define NSLog(...) do{} while(0)
#endif

/*
    颜色相关
 */
//设置颜色
#define RGBAColor(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
//设置16进制颜色
#define XColor(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#endif /* HHGlobal_h_h */
