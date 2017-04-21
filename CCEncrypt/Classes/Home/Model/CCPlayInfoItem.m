//
//  CCPlayInfoItem.m
//  CCEncrypt
//
//  Created by 陈超 on 17/4/8.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "CCPlayInfoItem.h"

#import "CCDefines.h"

@implementation CCPlayInfoItem

- (void)setAllnum:(NSString *)allnum {
    _allnum = [allnum copy];
    
//    观众: 1
    NSDictionary *attributes = @{NSForegroundColorAttributeName : CCColorARC};
    NSMutableAttributedString *allnumAttributed = [[NSMutableAttributedString alloc] initWithString:allnum attributes:attributes];
    [allnumAttributed insertAttributedString:[[NSAttributedString alloc] initWithString:@"观众: "] atIndex:0];
    _allnumAttributed = allnumAttributed;
}

- (void)setGps:(NSString *)gps {
    _gps = [gps copy];
    
    // 图片 + 位置
    NSTextAttachment *localAttachment = [NSTextAttachment new];
    UIImage *address = [UIImage imageNamed:@"address"];
    localAttachment.image = address;
    localAttachment.bounds = CGRectMake(kMZero, -1, address.size.width, address.size.height);
    NSMutableAttributedString *gpsAttributed = [[NSMutableAttributedString alloc] initWithString:gps attributes:nil];
    [gpsAttributed insertAttributedString:[NSAttributedString attributedStringWithAttachment:localAttachment] atIndex:0];
    _gpsAttributed = gpsAttributed;
}

@end
