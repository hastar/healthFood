//
//  LXFoodNetWork.m
//  测试美容列表URL
//
//  Created by lanou on 15/6/20.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "LXFoodNetWork.h"



#define kCatagoryBaseURL @"http://api.hoto.cn/index.php?appid=2&appkey=9ef269eec4f7a9d07c73952d06b5413f&format=json&sessionid=1434701240092&vc=71&vn=4.11.1&loguid=0&deviceid=haodou861022009913817&uuid=1496d32adedbc06cbb3d7f3e27e7f42e&channel=default_v4111&method=Search.getList&virtual=&signmethod=md5&v=2"
#define kFoodBaseURL @"http://api.hoto.cn/index.php?appid=2&appkey=9ef269eec4f7a9d07c73952d06b5413f&format=json&sessionid=1434720381362&vc=71&vn=4.11.1&loguid=0&deviceid=haodou861022009913817&uuid=1496d32adedbc06cbb3d7f3e27e7f42e&channel=default_v4111&method=Info.getInfo&virtual=&signmethod=md5&v=2"
#define kSearchBaseURL @"http://api.hoto.cn/index.php?appid=2&appkey=9ef269eec4f7a9d07c73952d06b5413f&format=json&sessionid=1434935883102&vc=71&vn=4.11.1&loguid=0&deviceid=haodou861022009913817&uuid=1496d32adedbc06cbb3d7f3e27e7f42e&channel=default_v4111&method=Search.getList&virtual=&signmethod=md5&v=2"

@implementation LXFoodNetWork

/**
 *  通过分类ID，返回分类ID对应的数据(json解析后的数据)
 *
 *  @param categoryId 数组，包含多个分类ID
 *
 *  @return 返回数据数组
 */
+(NSArray *)arrayWithCategoryIds:(NSArray *)categoryId
{
    NSMutableArray *dataArray = [[[NSMutableArray alloc] initWithCapacity:2] autorelease];
    
    for (NSString *id in categoryId) {
        
        NSString *paramString = [NSString stringWithFormat:@"limit=%d&scene=t1&tagid=%@&uuid=1496d32adedbc06cbb3d7f3e27e7f42e&offset=%d", 50, id, 0];
        
        
        NSData *data = [[[LXNetWork alloc] sendSynchronousWithUrl:kCatagoryBaseURL andParam:paramString andResultBlock:^(NSData *resultData) {
         
        }] autorelease];
        
        [dataArray addObject:data];
    }
    
    
    return dataArray;
}


/**
 *  返回再次请求的数据
 *
 *  @param categoryId 分类ID数组
 *  @param limit      每次请求多少条
 *  @param offsset    从第几条开始请求
 *
 *  @return 返回请求回来的数据数组
 */
+(NSArray *)arrayWithCategoryIds:(NSArray *)categoryId andLimit:(NSInteger)limit andOffset:(NSInteger)offsset
{
    if (categoryId == nil || categoryId.count == 0) {
        return nil;
    }
    
    NSMutableArray *dataArray = [[[NSMutableArray alloc] initWithCapacity:2] autorelease];
    
    for (NSString *id in categoryId) {
        
        NSString *paramString = [NSString stringWithFormat:@"limit=%ld&scene=t1&tagid=%@&uuid=1496d32adedbc06cbb3d7f3e27e7f42e&offset=%ld", (long)limit, id, (long)offsset];
        
        
        NSData *data = [[LXNetWork alloc] sendSynchronousWithUrl:kCatagoryBaseURL andParam:paramString andResultBlock:^(NSData *resultData) {
        }];
        
        [dataArray addObject:data];
    }
    
    
    return dataArray;
}

/**
 *  利用异步网络获取菜谱数据
 *
 *  @param categoryId 分类ID数组
 *  @param limit      每次请求多少条
 *  @param offsset    从第几条开始请求
 *  @param block      结果处理Block
 */
+(void)arrayWithCategoryIds:(NSArray *)categoryId andLimit:(NSInteger)limit andOffset:(NSInteger)offsset andResultBlock:(arrayBlock)block
{
    if (categoryId == nil || categoryId.count == 0) {
        return ;
    }
    
    NSMutableArray *dataArray = [[[NSMutableArray alloc] initWithCapacity:2] autorelease];
    __block NSUInteger count = categoryId.count;
    NSLock *countLock = [[NSLock alloc] init];
    for (NSString *id in categoryId)
    {
        NSString *paramString = [NSString stringWithFormat:@"limit=%ld&scene=t1&tagid=%@&uuid=1496d32adedbc06cbb3d7f3e27e7f42e&offset=%ld", (long)limit, id, (long)offsset];
        
        
        [LXNetWork sendASynchronousWithUrl:kSearchBaseURL andParam:paramString andResultBlock:^(NSData *resultData) {
            if(resultData != nil)
            {
                [dataArray addObject:resultData];
            }
            
            [countLock lock];
            count -= 1;
            if (count <= 0) {
                block(dataArray);
            }
            [countLock unlock];
            
        }];
    }
    
    [countLock release];
}


+(NSData *)dataWithSearchTextL:(NSString *)searchText
{
    if (searchText.length == 0) {
        return nil;
    }
    
    NSString *paramString = [NSString stringWithFormat:@"limit=200&scene=k1&uuid=1496d32adedbc06cbb3d7f3e27e7f42e&offset=0&keyword=%@", [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];


    NSData *data = [[LXNetWork alloc] sendSynchronousWithUrl:kCatagoryBaseURL andParam:paramString andResultBlock:^(NSData *resultData) {
    }];
    
    
    return data;
}

+(void)dataWithSearchTextL:(NSString *)searchText andResultBlock:(resultBlock)block
{
    if (searchText.length == 0) {
        block(nil);
        return ;
    }
    
    NSString *paramString = [NSString stringWithFormat:@"limit=20&scene=k1&uuid=1496d32adedbc06cbb3d7f3e27e7f42e&offset=0&keyword=%@", [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [LXNetWork sendASynchronousWithUrl:kSearchBaseURL andParam:paramString andResultBlock:^(NSData *resultData) {
        block(resultData);
    }];
    

}


/**
 *  异步请求数据
 *
 *  @param categoryId 分类
 *  @param limit      每次请求多少条
 *  @param offsset    从第几条开始请求
 *  @param finishData 数据请求完后调用的Block
 */
+(void)sendAsynWithCategoryIds:(NSArray *)categoryId andLimit:(NSInteger)limit andOffset:(NSInteger)offsset andFinishData:(resultBlock)finishData
{
    if (categoryId == nil || categoryId.count == 0) {
        
    }
    
    NSMutableArray *dataArray = [[[NSMutableArray alloc] initWithCapacity:2] autorelease];
    
    for (NSString *id in categoryId) {
        
        NSString *paramString = [NSString stringWithFormat:@"limit=%ld&scene=t1&tagid=%@&uuid=1496d32adedbc06cbb3d7f3e27e7f42e&offset=%ld", (long)limit, id, (long)offsset];
        
        
        NSData *data = [[LXNetWork alloc] sendSynchronousWithUrl:kCatagoryBaseURL andParam:paramString andResultBlock:^(NSData *resultData) {
            
            
        }];
        
        [dataArray addObject:data];
    }

}

-(void) clearCaches
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}


/**
 *  返回某菜品的详细信息data数据
 *
 *  @param foodId 菜品的ID
 *
 *  @return 信息数据
 */
+(NSData *)dataWithFoodId:(NSString *)foodId
{
    NSString *paramString = [NSString stringWithFormat:@"uuid=1496d32adedbc06cbb3d7f3e27e7f42e&rid=%@", foodId];
    NSData *data = [[LXNetWork alloc] sendSynchronousWithUrl:kFoodBaseURL andParam:paramString andResultBlock:^(NSData *resultData) {
        
    }];
    
    return data;
}


/**
 *  返回某菜品的详细信息data数据
 *
 *  @param foodId      菜品的ID
 *  @param resultBlock 接收菜谱数据的Block
 */
+(void)dataWithFoodId:(NSString *)foodId andBlock:(resultBlock)resultBlock;
{
   NSString *paramString = [NSString stringWithFormat:@"uuid=1496d32adedbc06cbb3d7f3e27e7f42e&rid=%@", foodId];
    
    [LXNetWork sendASynchronousWithUrl:kFoodBaseURL andParam:paramString andResultBlock:^(NSData *resultData) {
        resultBlock(resultData);
    }];

}


@end













