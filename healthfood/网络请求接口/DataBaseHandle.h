//
//  DataBaseHandle.h
//  healthfood
//
//  Created by lanou on 15/7/7.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DetailModel;
@class CategoryListModel;
@interface DataBaseHandle : NSObject


/***************************收藏相关*********************************/
/**
 *  将详情数据收藏到数据库
 *
 *  @param detailModel 详情数据
 *
 *  @return 返回收藏结果
 */
+ (BOOL) collectDetailModel:(DetailModel *)detailModel;

/**
 *  判断是否已经收藏
 *
 *  @param detailModel 判断的数据
 *
 *  @return 返回收藏结果
 */
+ (BOOL) isCollectWithDetailModel:(DetailModel *)detailModel;
+ (BOOL) isCollectWithModelRecipId:(NSString *)recipId;

/**
 *  删除收藏数据
 *
 *  @param detailModel 需要删除的数据
 *
 *  @return 返回删除结果
 */
+ (BOOL) deleteDetailModel:(DetailModel *)detailModel;
+ (BOOL) deleteDetailModelWithRecipId:(NSString *)recipId;

+ (BOOL) deleteAllDetailModel;

/**
 *  获取所有收藏数据
 *
 *  @return 返回数据数组
 */
+ (NSArray *) arrayWithCollectModels;


/***************************持久化相关*********************************/

/**
 *  持久化数据
 *
 *  @param dataArray 需要保存的数据数组
 *  @param limit     最多保存多少个数据
 *
 *  @return 返回保存结果
 */
+ (BOOL) saveLocalListModels:(NSArray *)dataArray withLimit:(NSInteger)limit;

+ (BOOL) saveLocalListModels:(NSArray *)dataArray;


/**
 *  读取本地数据
 *
 *  @param offset 从第几条开始读起
 *  @param limit  每次读取多少条
 *
 *  @return 返回本地数据数组
 */
+ (NSArray *) readLocalListModelsWithLimit:(NSInteger)limit;

+ (NSArray *) readLocalListModels;

/***************************持久化相关*********************************/

/**
 *  保存临时数据
 *
 *  @param dataArray 要保存的数组
 *  @param fromIndex 数组中的开始序号
 *  @param toIndex   数组中的结束序号
 *
 *  @return 返回保存成功结果
 */
+ (BOOL) saveTempListModels:(NSArray *)dataArray fromIndex:(NSInteger)fromIndex andToIndex:(NSInteger)toIndex;

/**
 *  读取临时数据
 *
 *  @param offset 偏移量
 *  @param limit  读取的数量
 *
 *  @return 返回临时数据数组
 */
+ (NSArray *) readTempListModelsWithOffset:(NSInteger)offset andLimit:(NSInteger)limit;






@end
