//
//  CCHomeViewController.m
//  CCEncrypt
//
//  Created by 陈超 on 17/3/12.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "CCHomeViewController.h"

#import <MJRefresh/MJRefresh.h>

#import "CCDefines.h"

#import "CCPlayingCollectionCell.h"

#import "CCPlaysCollect.h"
#import "CCRequestHelper.h"

#import "CCPlayingController.h"
#import "CCPlayingCollectionController.h"


static NSString *const playingListCell = @"playingListCell";

@interface CCHomeViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nullable, nonatomic, weak) UITableView *playingListView;

@property (nonatomic, assign) NSInteger page;

/** 管理直播列表对象 */
@property (nullable, nonatomic, strong) CCPlaysCollect *playsCollect;

@end

@implementation CCHomeViewController

#pragma mark - Reload
- (void)loadView {
    [self loadView_];
}

- (void)controllerSpecialInit {
    // 特定初始化
    _page = 0;
    
    // 请求数据
    [self requestListDataIsNext:NO];
}

- (void)controllerLayoutSubviews {
    
}


#pragma mark - Common
#pragma mark - Special
- (void)loadView_ {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = kMTen;
    
    CGFloat kScreenW = CCScreenWidth;
    flowLayout.itemSize = CGSizeMake(kScreenW, kScreenW + 50.0f);
    
    UICollectionView *playingListView = [[UICollectionView alloc] initWithFrame:CCScreenBounds collectionViewLayout:flowLayout];
    playingListView.contentInset = UIEdgeInsetsMake(kMStateNavH, kMZero, kMTabH, kMZero);
    playingListView.delegate = self;
    playingListView.dataSource = self;
    [playingListView registerNib:[UINib nibWithNibName:NSStringFromClass([CCPlayingCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:playingListCell];
    weakSelf(self);
    playingListView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [weakself requestListDataIsNext:NO];
    }];
    playingListView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        [weakself requestListDataIsNext:YES];
    }];
    self.view = playingListView;
}

- (void)requestListDataIsNext:(BOOL)next {
    _page = next ? _page + 1 : 1;
    
    weakSelf(self)
    [CCRequestHelper requestPlayingList:_page requestResult:^(id response, NSError *error) {
        if (error) {
            
        } else {
            if (_page == 1) {
                weakself.playsCollect.items = response;
            } else {
                [weakself.playsCollect.items addObjectsFromArray:response];
            }
            [(UICollectionView *)weakself.view reloadData];
        }
        [[(UITableView *)weakself.view mj_header] endRefreshing];
        [[(UITableView *)weakself.view mj_footer] endRefreshing];
    }];
}

#pragma mark - Event

#pragma mark - Protocol
/// UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.playsCollect.items ? _playsCollect.items.count : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CCPlayingCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:playingListCell forIndexPath:indexPath];
    [cell setValue:_playsCollect.items[indexPath.row] forKeyPath:@"item"];
    return cell;
}

/// UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _playsCollect.currentItem = _playsCollect.items[indexPath.row];
    
//    CCPlayingController *playController = [CCPlayingController sharedPlayController];
    CCPlayingCollectionController *playController = [CCPlayingCollectionController new];
    playController.playsCollect = _playsCollect;
    [self.navigationController pushViewController:playController animated:YES];
}


#pragma mark - Lazy
- (CCPlaysCollect *)playsCollect {
    if (!_playsCollect) {
        _playsCollect = [CCPlaysCollect new];
    }
    return _playsCollect;
}


@end


