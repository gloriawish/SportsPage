//
//  SPSportsPageShareView.m
//  SportsPage
//
//  Created by Qin on 2017/3/29.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPSportsPageShareView.h"

#import "SPSportsPageShareCollectionViewCell.h"

#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>

@interface SPSportsPageShareView () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout> {
    NSMutableArray <NSNumber *> *_shareDataArray;
    
    NSString *_title;
    NSString *_time;
    NSString *_location;
    NSString *_image;
    NSString *_eventId;
    
    BOOL _isNotNeedToSportsPageShareType;
}

@property (weak, nonatomic) IBOutlet UICollectionView *shareCollectionView;

@end

@implementation SPSportsPageShareView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

#pragma mark - SetUp
- (void)setUp {
    [self setUpShareCollectionView];
    [self setUpShareDataArray];
}

- (void)setUpShareCollectionView {
    _shareCollectionView.delegate = self;
    _shareCollectionView.dataSource = self;
    
    [_shareCollectionView registerNib:[UINib nibWithNibName:@"SPSportsPageShareCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SportsPageShareCollectionViewCell"];
}

- (void)setUpShareDataArray {

    _shareDataArray = [[NSMutableArray alloc] init];
    if (!_isNotNeedToSportsPageShareType) {
        [_shareDataArray addObject:@(SPSportsPageShareTypeSportsPage)];
    }
    
    if ([WXApi isWXAppInstalled]) {
        [_shareDataArray addObject:@(SPSportsPageShareTypeWeChatFriends)];
        [_shareDataArray addObject:@(SPSportsPageShareTypeWeChatTimeLine)];
    }
    
    if ([TencentOAuth iphoneQQInstalled]) {
        [_shareDataArray addObject:@(SPSportsPageShareTypeQQ)];
        [_shareDataArray addObject:@(SPSportsPageShareTypeQQZone)];
    }
    
    [_shareCollectionView reloadData];
}

- (void)isNotNeedToSportsPageShareType {
    _isNotNeedToSportsPageShareType = true;
    if ([_shareDataArray containsObject:@(SPSportsPageShareTypeSportsPage)]) {
        [_shareDataArray removeObject:@(SPSportsPageShareTypeSportsPage)];
        
        if (_shareDataArray.count == 0) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
            label.text = @"暂未安装微信、QQ。";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            [_shareCollectionView addSubview:label];
        }
        
    }
}

- (void)onlyNeedToSportsPageShareType {
    [_shareDataArray removeAllObjects];
    [_shareDataArray addObject:@(SPSportsPageShareTypeSportsPage)];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _shareDataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SPSportsPageShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SportsPageShareCollectionViewCell" forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(SPSportsPageShareCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [cell setUpShareType:[_shareDataArray[indexPath.item] integerValue]];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(85, 85);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    
    SPSportsPageShareType type = [_shareDataArray[indexPath.item] integerValue];
    
    if (type == SPSportsPageShareTypeSportsPage) {
        if ([_delegate respondsToSelector:@selector(cancelShareView)]) {
            [_delegate cancelShareView];
        }
        
        if ([_delegate respondsToSelector:@selector(finishedShareToSportsPage)]) {
            [_delegate finishedShareToSportsPage];
        }
    } else if (type == SPSportsPageShareTypeWeChatFriends) {
        if ([_delegate respondsToSelector:@selector(cancelShareView)]) {
            [_delegate cancelShareView];
        }
        
        if ([_delegate respondsToSelector:@selector(finishedShareToWeChatFriends)]) {
            [_delegate finishedShareToWeChatFriends];
        }
    } else if (type == SPSportsPageShareTypeWeChatTimeLine) {
        if ([_delegate respondsToSelector:@selector(cancelShareView)]) {
            [_delegate cancelShareView];
        }
        
        if ([_delegate respondsToSelector:@selector(finishedShareToWeChatTimeLine)]) {
            [_delegate finishedShareToWeChatTimeLine];
        }
    } else if (type == SPSportsPageShareTypeQQ) {
        if ([_delegate respondsToSelector:@selector(cancelShareView)]) {
            [_delegate cancelShareView];
        }
        
        if ([_delegate respondsToSelector:@selector(finishedShareToQQ)]) {
            [_delegate finishedShareToQQ];
        }
    } else if (type == SPSportsPageShareTypeQQZone) {
        if ([_delegate respondsToSelector:@selector(cancelShareView)]) {
            [_delegate cancelShareView];
        }
        
        if ([_delegate respondsToSelector:@selector(finishedShareToQQZone)]) {
            [_delegate finishedShareToQQZone];
        }
    }
    
}

#pragma mark - TouchesBegan
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint clickPoint = [touch locationInView:_shareView];
    if (!CGRectContainsPoint(_shareView.bounds, clickPoint)) {
        if ([_delegate respondsToSelector:@selector(cancelShareView)]) {
            [_delegate cancelShareView];
        }
    }
}

@end
