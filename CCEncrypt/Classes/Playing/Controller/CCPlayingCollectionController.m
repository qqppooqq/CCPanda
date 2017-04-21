//
//  CCPlayingCollectionController.m
//  CCEncrypt
//
//  Created by 陈超 on 17/4/10.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "CCPlayingCollectionController.h"

#import "CCToolDefines.h"

#import "CCRefresh.h"

#import "CCPlaysCollect.h"
#import "CCPlayView.h"
#import "CCPlayViewCell.h"


static NSString *const kPlayViewCell = @"kPlayViewCell";

@interface CCPlayingCollectionController ()<UICollectionViewDelegate, UICollectionViewDataSource, CCPlayViewCellDelegate>


@end

@implementation CCPlayingCollectionController


#pragma mark - Reload
- (void)loadView {
    [self _loadView];
}

- (void)controllerSpecialInit {
    
}

- (void)controllerLayoutSubviews {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    /// 设置不自动调整ScrollView的内边距
//    /// 在父类中执行了一遍, 但是因为此控制器保持单例一直存储, 在pop出去后, 此值会莫名的改变为YES, 所以重复设置
//    self.automaticallyAdjustsScrollViewInsets = NO;
    /// 设置导航栏隐藏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    /// 设置导航栏展示
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)dealloc {
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}



#pragma mark - Common
- (void)_loadView {
    CCPlayView *playView = [CCPlayView playView];
    [playView registerClass:[CCPlayViewCell class] forCellWithReuseIdentifier:kPlayViewCell];
    [playView setDelegate:self];
    [playView setDataSource:self];
    weakSelf(self);
    playView.mj_header = [CCGifHeader headerWithRefreshingBlock:^{
        // 切换到上一个主播
        [weakself displayCurrentItemIsNext:NO];
    }];
    playView.mj_footer = [CCGitFooter footerWithRefreshingBlock:^{
        // 切换到下一个主播
        [weakself displayCurrentItemIsNext:YES];
    }];
    self.view = playView;
}

#pragma mark - Special
- (void)displayCurrentItemIsNext:(BOOL)next {
    NSInteger index = [_playsCollect.items indexOfObject:_playsCollect.currentItem];
    
    if (next) {
        [[(CCPlayView *)self.view mj_footer] endRefreshing];
        if (index == _playsCollect.items.count - 1) return ;
        index += 1;
    } else {
        [[(CCPlayView *)self.view mj_header] endRefreshing];
        if (!index) return ;
        index -= 1;
    }
    
    _playsCollect.currentItem = _playsCollect.items[index];
    
    [(CCPlayView *)self.view reloadData];
}


#pragma mark - Event
- (void)handleDidExitEvent {
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark - Protocol
/// UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CCPlayViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPlayViewCell forIndexPath:indexPath];
    [(CCPlayViewCell *)cell setPlaysCollect:_playsCollect];
    cell.delegate = self;
    return cell;
}


/// UICollectionViewDelegate


/// CCPlayViewCellDelegate
- (void)playViewCellDidExitPlay:(CCPlayViewCell *)cell {
    [self handleDidExitEvent];
}


#pragma mark - Lazy





@end
