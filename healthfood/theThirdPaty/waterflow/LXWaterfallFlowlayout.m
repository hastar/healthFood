//
//  LXWaterfallFlowlayout.m
//  CollectionDemo
//
//  Created by lanou on 15/7/7.
//  Copyright © 2015年 hastar. All rights reserved.
//

#import "LXWaterfallFlowlayout.h"

@interface LXWaterfallFlowlayout ()

// 所有item的属性的数组
@property (nonatomic, strong) NSArray *layoutAttributesArray;

//item 的数量
@property (nonatomic, assign) NSUInteger numberOfItems;

@end

@implementation LXWaterfallFlowlayout



-(NSArray *)layoutAttributesArray
{
    if (_layoutAttributesArray == nil) {
        _layoutAttributesArray = [NSArray array];
    }
    
    return  _layoutAttributesArray;
}

/**
 *  布局准备方法  当collectionView的布局发生变化时会被调用
 *  通常是坐布局的准备工作 itemSize......
 *  UICollectionView 的contentSize 是根据itemSize 动态计算出来的
 */
- (void)prepareLayout
{
    CGFloat contentWidth = self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right;
    CGFloat marginX = self.minimumInteritemSpacing;
    CGFloat itemWidth = (contentWidth - marginX * (self.columnCount - 1)) / self.columnCount;
    
    [self computeAttributesWithItemWidth:itemWidth];
}

/**
 *  根据 itemWidth计算布局属性
 *
 *  @param itemWidth
 */
- (void)computeAttributesWithItemWidth:(CGFloat)itemWidth
{
    //定义一个列高数组 记录每一列的总高度
    CGFloat columnHeight[self.columnCount];
    
    //定义一个记录每一列的总item个数的数组
    NSInteger columnItemCount[self.columnCount];
    
    //初始化
    for (int i = 0; i < self.columnCount; i++) {
        columnHeight[i] = self.sectionInset.top;
        columnItemCount[i] = 0;
    }
    
    //遍历goodsList 数组计算相关属性
    NSInteger index = 0;
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:self.columnCount];
    
    self.numberOfItems = 0;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfItemsInCollectionView)]) {
        //通过代理获取item的个数
        self.numberOfItems = [self.delegate numberOfItemsInCollectionView];
    }
    
    
    
    for (int i = 0; i < self.numberOfItems; i++) {
        //建立布局属性
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        //这一步就是设置下一个item从哪里出来
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        //找出最短列号
        NSInteger column = [self shortestColumn:columnHeight];
        //数据追加在最短列上
        columnItemCount[column]++;
        //x值
        CGFloat itemX = (itemWidth + self.minimumInteritemSpacing) * column + self.sectionInset.left;
        //y值
        CGFloat itemY = columnHeight[column];
        
        //等比例缩放，计算item的高度
        CGFloat itemH = 0.0;
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:waterFlowLayout:heightForItemAtIndexPath:)]) {
            itemH = [self.delegate collectionView:self.collectionView waterFlowLayout:self heightForItemAtIndexPath:indexPath];
        }
        
        //设置frame
        attributes.frame = CGRectMake(itemX, itemY, itemWidth, itemH);
        [attributesArray addObject:attributes];
        
        //累加高度
        columnHeight[column] += itemH + self.minimumLineSpacing;
        
        index++;
        
    }
    NSLog(@"lastHeight = %.2f,  %.2f", columnHeight[0], columnHeight[1]);
    
    // 找出最高列列号
    NSInteger column = [self highestColumn:columnHeight];
    
    //根据最高列设置 itemSize 使用总高度的平均值
//    CGFloat itemH = (columnHeight[column] - self.minimumLineSpacing * columnItemCount[column]) / columnItemCount[column];
    CGFloat itemH = (columnHeight[column]  - self.minimumLineSpacing * (columnItemCount[column]+1)) / columnItemCount[column];
//    CGFloat itemH = columnHeight[column] / columnItemCount[column];
    NSLog(@"itemH = %.2f", itemH);
    self.itemSize = CGSizeMake(itemWidth, itemH);//这里相当于scrollView 的contentSize
    
    
    
    //添加页脚属性
//    NSIndexPath *footerIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
//    UICollectionViewLayoutAttributes *footerAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:footerIndexPath];
//    footerAttr.frame = CGRectMake(0, columnHeight[column], self.collectionView.bounds.size.width, 50);
//    [attributesArray addObject:footerAttr];
    
    //给属性数组设置数值
    self.layoutAttributesArray = attributesArray.copy;
}

/**
 *  找出columnHeight数组中最短列序号 
 *  追加数据的时候追加在最短列中
 *
 *  @param columnHeight 列高度
 *
 *  @return 返回列号
 */
- (NSInteger)shortestColumn:(CGFloat *)columnHeight
{
    CGFloat max = CGFLOAT_MAX;
    NSInteger column = 0;
    
    for (int i = 0; i < self.columnCount; i++) {
        if (columnHeight[i] < max) {
            max = columnHeight[i];
            column = i;
        }
    }
    
    return column;
}

/**
 *  找出columnHeight 数组中最高列号
 *
 *  @param columnHeight 列高
 *
 *  @return 列号
 */
- (NSInteger)highestColumn:(CGFloat *)columnHeight
{
    CGFloat min = 0;
    NSInteger column = 0;
    for (int i = 0; i < self.columnCount; i++) {
        if (columnHeight[i] > min) {
            min = columnHeight[i];
            column = i;
        }
    }
    
    
    return column;
}

/**
 *  跟踪效果：当到达要显示的区域时，会计算所有显示item的属性
            一旦计算完成所有的属性会被缓存 不会再次计算
 *
 *  @param rect
 *
 *  @return 返回布局属性数组
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.layoutAttributesArray;
}













@end
