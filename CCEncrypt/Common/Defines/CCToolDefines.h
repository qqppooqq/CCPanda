//
//  CCToolDefines.h
//  CCEncrypt
//
//  Created by MTCC on 16/11/3.
//  Copyright © 2016年 CC. All rights reserved.
//

#ifndef CCToolDefines_h
#define CCToolDefines_h


/* --国际化(本地化)-- */
#undef L
#define L(key) \
[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]


/* --沙盒中文件路径-- */
#define CCSearchDirectory(NSDirectory) [NSSearchPathForDirectoriesInDomains((NSDirectory), NSUserDomainMask, YES) lastObject]
#define CCSearchCaches CCSearchDirectory(NSCachesDirectory)
#define CCSearchDocument CCSearchDirectory(NSDocumentDirectory)
#define CCSearchTemp NSTemporaryDirectory()


/* --通知中心-- */
#define CCNotificationCenter [NSNotificationCenter defaultCenter]


/* --偏好存储-- */
#define CCUserDefault [NSUserDefaults standardUserDefaults]


/* --日志输出-- */
#ifdef DEBUG // 开发: 分别是方法地址，文件名，在文件的第几行，自定义输出内容
#define CCLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else   // 发布
#define CCLog( s, ... )
#endif


/* --颜色-- */
// rgb颜色转换（16进制->10进制）
#define CCColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define CCColorRGB(r, g, b) CCColorRGBA(r, g, b, 1.0)
#define CCColor16Binary(rgbValue) CCColorRGBA((((rgbValue) & 0xFF0000) >> 16), (((rgbValue) & 0xFF00) >> 8), ((rgbValue) & 0xFF));
#define CCColorARC CCColorRGB(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))


/* --弱引用/强引用-- */
#define weakSelf(type)  __weak typeof(type) weak##type = type;
#define strongSelf(type)  __strong typeof(type) type = weak##type;


/* --Degrees角度 / Radian弧度-- */
#define CCDegreesToRadian(x) (M_PI * (x) / 180.0)
#define CCRadianToDegrees(radian) ((radian) * 180.0) / (M_PI)


/* --GCD-- */
#define CCGCDBACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define CCGCDMAIN(block) dispatch_async(dispatch_get_main_queue(),block)


/* 序列号字典 */
// NSDictionaryOfVariableBindings

#endif /* CCToolDefines_h */
