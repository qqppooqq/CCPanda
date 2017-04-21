//
//  CCPlayInfoItem.h
//  CCEncrypt
//
//  Created by 陈超 on 17/4/8.
//  Copyright © 2017年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCPlayInfoItem : NSObject

@property (nullable, nonatomic, copy) NSString *pos;
/** 房间人数 - 猜测 */
@property (nullable, nonatomic, copy) NSString *allnum;
/** 房间id */
@property (nullable, nonatomic, copy) NSString *roomid;
@property (nullable, nonatomic, copy) NSString *serverid;
/** 主播位置 */
@property (nullable, nonatomic, copy) NSString *gps;
/** 直播地址 */
@property (nullable, nonatomic, copy) NSString *flv;
@property (nullable, nonatomic, copy) NSString *starlevel;
@property (nullable, nonatomic, copy) NSString *familyName;
@property (nullable, nonatomic, copy) NSString *isSign;
@property (nullable, nonatomic, copy) NSString *nation;
@property (nullable, nonatomic, copy) NSString *nationFlag;
@property (nullable, nonatomic, copy) NSString *distance;
@property (nullable, nonatomic, copy) NSString *useridx;
@property (nullable, nonatomic, copy) NSString *userId;
@property (nullable, nonatomic, copy) NSString *gender;
/** 主播名 */
@property (nullable, nonatomic, copy) NSString *myname;
/** 主播描述 */
@property (nullable, nonatomic, copy) NSString *signatures;
/** 小图 */
@property (nullable, nonatomic, copy) NSString *smallpic;
/** 大图 */
@property (nullable, nonatomic, copy) NSString *bigpic;
@property (nullable, nonatomic, copy) NSString *level;
@property (nullable, nonatomic, copy) NSString *grade;
@property (nullable, nonatomic, copy) NSString *curexp;

/** 记录所需要的地理的AttributedString */
@property (nullable, nonatomic, strong) NSAttributedString *gpsAttributed;
/** 记录所需要的人数的AttributedString */
@property (nullable, nonatomic, strong) NSAttributedString *allnumAttributed;

@end
