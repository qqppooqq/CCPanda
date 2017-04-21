//
//  CCViewDefines.h
//  CCEncrypt
//
//  Created by MTCC on 16/11/3.
//  Copyright © 2016年 CC. All rights reserved.
//

#ifndef CCViewDefines_h
#define CCViewDefines_h


/* --屏幕宽高-- */
#define CCScreenBounds  [UIScreen mainScreen].bounds
#define CCScreenWidth   CCScreenBounds.size.width
#define CCScreenHeight  CCScreenBounds.size.height
#define CCStatusBarFrame [[UIApplication sharedApplication] statusBarFrame]


/* --字体-- */
#define CCFont(size)    [UIFont systemFontOfSize:(size)]
#define CCFontName(NAME, size)    [UIFont fontWithName:(NAME) size:(size)]
#define CCFontFZHT(size) CCFontName(@"FZHTJW--GB1-0", (size))
#define CCFontYAHEI(size) CCFontName(@"MicrosoftYaHei", (size))
#define CCFontENGLISH(size) CCFontName(@"Helvetica Light", (size))

// [UIFont fontWithName:@"FZHTJW--GB1-0" size:(size)] // 方正黑体简体字体定义


#endif /* CCViewDefines_h */
