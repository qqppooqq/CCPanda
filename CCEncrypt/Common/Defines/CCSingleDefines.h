//
//  CCSingleDefines.h
//  CCEncrypt
//
//  Created by MTCC on 16/11/3.
//  Copyright © 2016年 CC. All rights reserved.
// /*-------------- 单例宏 --------*/

/*
 #if __has_feature(objc_arc)
 // ARC
 #else
 // MRC
 #endif
 */

#ifndef CCSingleDefines_h
#define CCSingleDefines_h

/**
 *  声明单例对象工厂方法
 *  @param name shared后紧跟的名称
 */
#define SingleInterFace(name) + (nonnull instancetype)shared##name;
// 实现
#if __has_feature(objc_arc)
// 如果是ARC
#define SingleImplementation(name) SingleGeneral(name)
#else
// 如果不是ARC
#define SingleImplementation(name)  SingleGeneral(name) \
- (oneway void)release                      { } \
- (instancetype)retain                      { return _instance; } \
- (NSUInteger)retainCount                   { return MAXFLOAT; }
#endif
// ARC / MRC的共性
/**
 *  实现单例对象工厂方法
 *  @param name shared后紧跟的名称
 */
#define SingleGeneral(name) + (instancetype)shared##name \
{ return [[self alloc] init]; } \
static id _instance; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
- (id)copyWithZone:(NSZone *)zone           { return _instance; } \
- (id)mutableCopyWithZone:(NSZone *)zone    { return _instance; } \

#endif /* CCSingleDefines_h */
