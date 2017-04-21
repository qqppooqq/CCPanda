//
//  CCPlayingCollectionCell.m
//  CCEncrypt
//
//  Created by 陈超 on 17/4/8.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "CCPlayingCollectionCell.h"

#import <YYKit/UIImage+YYAdd.h>
#import <YYKit/UIImageView+YYWebImage.h>

#import "CCDefines.h"

#import "CCPlayInfoItem.h"



@interface CCPlayingCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gpsLabel;
@property (weak, nonatomic) IBOutlet UILabel *lookCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playingImageView;

@end


@implementation CCPlayingCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


#pragma mark - Lazy
- (void)setItem:(CCPlayInfoItem *)item {
    _item = item;

    _nameLabel.text = item.myname;
    _gpsLabel.attributedText = item.gpsAttributed;
    _lookCountLabel.attributedText = item.allnumAttributed;
    
    [_iconImageView setImageWithURL:[NSURL URLWithString:item.smallpic] placeholder:[UIImage imageNamed:kIconPlaceHold] options:kNilOptions completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
        UIRectCorner corner = UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft;
        
        _iconImageView.image = [image imageByRoundCornerRadius:image.size.width * 0.5 corners:corner borderWidth:2.0f borderColor:[UIColor purpleColor] borderLineJoin:kCGLineJoinRound];
    }];
    
    [_playingImageView setImageWithURL:[NSURL URLWithString:item.bigpic] placeholder:[UIImage imageNamed:kImagePlaceHold]];
}


@end
