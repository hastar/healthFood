//
//  LXFoodNetWork.h
//  测试美容列表URL
//
//  Created by lanou on 15/6/20.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXNetWork.h"

typedef void (^arrayBlock)(NSArray *dataArray);

@interface LXFoodNetWork : LXNetWork

/**
 *  通过分类ID，返回分类ID对应的数据
 *
 *  @param categoryId 数组，包含多个分类ID
 *
 *  @return 返回数据数组
 */
+(NSArray *)arrayWithCategoryIds:(NSArray *)categoryId;

/**
 *  返回再次请求的数据
 *
 *  @param categoryId 分类ID数组
 *  @param limit      每次请求多少条
 *  @param offsset    从第几条开始请求
 *
 *  @return 返回请求回来的数据数组
 */
+(NSArray *)arrayWithCategoryIds:(NSArray *)categoryId andLimit:(NSInteger)limit andOffset:(NSInteger)offsset;

/**
 *  利用异步网络获取菜谱数据
 *
 *  @param categoryId 分类ID数组
 *  @param limit      每次请求多少条
 *  @param offsset    从第几条开始请求
 *  @param block      结果处理Block
 */
+(void)arrayWithCategoryIds:(NSArray *)categoryId andLimit:(NSInteger)limit andOffset:(NSInteger)offsset andResultBlock:(arrayBlock)block;

/**
 *  在利用同步网络上搜索菜谱
 *
 *  @param searchText 需要搜索的文字
 *
 *  @return 返回搜索的NSData数据结果
 */
+(NSData *)dataWithSearchTextL:(NSString *)searchText;

/**
 *  利用异步请求在网络上搜索菜谱
 *
 *  @param searchText 需要搜索的文字
 *  @param block      结果处理block
 */
+(void)dataWithSearchTextL:(NSString *)searchText andResultBlock:(resultBlock)block;

/**
 *  异步请求数据
 *
 *  @param categoryId 分类
 *  @param limit      每次请求多少条
 *  @param offsset    从第几条开始请求
 *  @param finishData 数据请求完后调用的Block
 */
+(void)sendAsynWithCategoryIds:(NSArray *)categoryId andLimit:(NSInteger)limit andOffset:(NSInteger)offsset andFinishData:(resultBlock)finishData;

/**
 *  返回某菜品的详细信息data数据
 *
 *  @param foodId 菜品的ID
 *
 *  @return 信息数据
 */
+(NSData *)dataWithFoodId:(NSString *)foodId;

/**
 *  返回某菜品的详细信息data数据
 *
 *  @param foodId      菜品的ID
 *  @param resultBlock 接收菜谱数据的Block
 */
+(void)dataWithFoodId:(NSString *)foodId andBlock:(resultBlock)resultBlock;

@end
