//
//  LXWaterfallFlowlayout.h
//  CollectionDemo
//
//  Created by lanou on 15/7/7.
//  Copyright © 2015年 hastar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class LXWaterfallFlowlayout;
@protocol LXWaterfallFlowlayoutDelegate <UICollectionViewDelegate>

@required
/**
 *  获取总共的item数量
 *
 *  @return item总数
 */
-(NSUInteger)numberOfItemsInCollectionView;

/**
 *  返回每个item自己的高度
 *
 *  @param collectionView 返回的高度在哪一个集合视图中使用
 *  @param layout         按照什么样的布局来返回高度
 *  @param indexPath      返回的是第几个item的高度
 *
 *  @return item的高度
 */
-(CGFloat)collectionView:(UICollectionView *)collectionView waterFlowLayout:(LXWaterfallFlowlayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface LXWaterfallFlowlayout : UICollectionViewFlowLayout

//总列数
@property (nonatomic, assign) NSUInteger columnCount;


//设置代理
@property (nonatomic, assign) id<LXWaterfallFlowlayoutDelegate> delegate;

@end
