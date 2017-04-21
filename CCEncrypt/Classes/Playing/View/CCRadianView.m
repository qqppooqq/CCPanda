//
//  CCRadianView.m
//  CCEncrypt
//
//  Created by 陈超 on 17/4/11.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "CCRadianView.h"

#pragma mark - View
@implementation CCRadianView

+ (Class)layerClass {
    return [CCRadianLayer class];
}

@end


@implementation CCPlayerRadianView



@end


@implementation CCPlayOtherInfo



@end


#pragma mark - Layer
@implementation CCRadianLayer

#pragma mark -- Reload
- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (void)layoutSublayers {
    CGRect bounds = self.bounds;
    CGFloat radius = MIN(bounds.size.width, bounds.size.height) * 0.5f;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radius];
    self.path = path.CGPath;
    
    [super layoutSublayers];
}


#pragma mark -- Common
- (void)commonInit {
    self.strokeColor = nil;
    self.fillColor = [UIColor colorWithWhite:0.0 alpha:0.13].CGColor;
}


@end
