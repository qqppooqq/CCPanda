//
//  CCPlayView.m
//  CCEncrypt
//
//  Created by 陈超 on 17/4/10.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "CCPlayView.h"

#import "CCDefines.h"

#import "CCPlayViewCell.h"


@interface CCPlayViewLayout : UICollectionViewFlowLayout

@end

@implementation CCPlayViewLayout

- (instancetype)init {
    if (self = [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumLineSpacing = kMZero;
        self.minimumInteritemSpacing = kMZero;
        
        self.itemSize = CCScreenBounds.size;
    }
    return self;
}

@end



@implementation CCPlayView

#pragma mark - Reload
+ (instancetype)playView {
    return [[self alloc] initWithFrame:CCScreenBounds collectionViewLayout:[CCPlayViewLayout new]];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Common
- (void)commonInit {
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.alwaysBounceHorizontal = NO;
    self.alwaysBounceVertical = YES;
}

#pragma mark - Special
#pragma mark - Event
#pragma mark - Protocol
#pragma mark - Lazy

@end
