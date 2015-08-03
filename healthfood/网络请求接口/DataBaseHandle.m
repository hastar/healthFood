//
//  DataBaseHandle.m
//  healthfood
//
//  Created by lanou on 15/7/7.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "DataBaseHandle.h"
#import "FMDB.h"
#import "DetailModel.h"
#import "CategoryListModel.h"


#ifdef DEBUG
    #define LXLog(...) NSLog(__VA_ARGS__)
#else
    #define LXLog(...)
#endif

@implementation DataBaseHandle

static FMDatabase *myDb = nil;

/**
 *  打开数据库
 */
+(void) openMyDb
{
    if (myDb == nil) {
        
        NSString *dirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePath = [dirPath stringByAppendingPathComponent:@"data.sqlite"];
        
        myDb = [FMDatabase databaseWithPath:filePath];
        if (![myDb open]) {
            [myDb release];
            return;
        }
        LXLog(@"%@", filePath);
    }
    
    [myDb retain];
}

+(BOOL) openCollectTable
{
    [self openMyDb];
    
    NSString *createTableSql = @"create table if not exists collectTable(recipId text primary key,data BLOB)";
    
    
    return [myDb executeUpdate:createTableSql];
}

+(BOOL) openLocalTable
{
    [self openMyDb];
    
    NSString *createTableSql = @"create table if not exists LocalTable(recipid text primary key,data BLOB)";
    
    
    return [myDb executeUpdate:createTableSql];
}

+(BOOL) openTempTable
{
    [self openMyDb];
    
    NSString *createTableSql = @"create table if not exists TempTable(listId INTEGER,recipid TEXT primary,data BLOB)";
    
    return [myDb executeUpdate:createTableSql];
}


/***************************收藏相关*********************************/
/**
 *  将详情数据收藏到数据库
 *
 *  @param detailModel 详情数据
 *
 *  @return 返回收藏结果
 */
+ (BOOL) collectDetailModel:(DetailModel *)detailModel
{
    [self openCollectTable];
   
    @try {
        
        NSMutableData *data= [[[NSMutableData alloc] init] autorelease];
        NSKeyedArchiver *archiver=[[[NSKeyedArchiver alloc] initForWritingWithMutableData:data] autorelease];
        
        //3.用该归档对象，把自定义的类转化为二进制data
        [archiver encodeObject:detailModel forKey:@"detailModel1"];
        [archiver finishEncoding];
    
        BOOL result = [myDb executeUpdate:@"insert into collectTable(recipId, data) values(?, ?)", [detailModel.RecipeId stringValue], data];
        
        if (!result) {
            LXLog(@"数据插入出错");
            
            return NO;
        }
        
        return YES;
    }
    @catch (NSException *exception) {
        LXLog(@"插入数据错误哦");
        return NO;
    }
    
    
    return NO;
}

/**
 *  判断是否已经收藏
 *
 *  @param detailModel 判断的数据
 *
 *  @return 返回收藏结果
 */
+ (BOOL) isCollectWithDetailModel:(DetailModel *)detailModel;
{
    return [self isCollectWithModelRecipId:[detailModel.RecipeId stringValue]];
}

+ (BOOL) isCollectWithModelRecipId:(NSString *)recipId
{
    [self openCollectTable];
    
    NSString *selectSql = [NSString stringWithFormat:@"select * from collectTable where recipid = %@", recipId];
    
    FMResultSet *resutlSet = nil;
    
    resutlSet = [myDb executeQuery:selectSql];
    if (resutlSet == nil) return  NO;
    
    if ([resutlSet next]) {
        return YES;
    }
    
    return NO;
}

/**
 *  删除收藏数据
 *
 *  @param detailModel 需要删除的数据
 *
 *  @return 返回删除结果
 */
+ (BOOL) deleteDetailModel:(DetailModel *)detailModel
{
    return [self deleteDetailModelWithRecipId:[detailModel.RecipeId stringValue]];
}
+ (BOOL) deleteDetailModelWithRecipId:(NSString *)recipId
{
    [self openCollectTable];
    
    return [myDb executeUpdateWithFormat:@"delete from collectTable where recipid = %@",recipId];
}

+ (BOOL) deleteAllDetailModel
{
    [self openCollectTable];
    
    return [myDb executeUpdateWithFormat:@"delete from collectTable"];
}




/**
 *  获取所有收藏数据
 *
 *  @return 返回数据数组
 */
+ (NSArray *) arrayWithCollectModels
{
    [self openCollectTable];
    
    NSString *selectSql = @"select recipid, data from collectTable";
    FMResultSet *resultSet = nil;
    resultSet = [myDb executeQuery:selectSql];
    if (resultSet == nil) return  nil;
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity:2];
    while ([resultSet next])
    {
        
        NSData *date = [resultSet dataForColumn:@"data"];
        @try {
            
            if (date == nil) {
                continue;
            }
            
            NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:date];
            DetailModel *model = [unArchiver decodeObjectForKey:@"detailModel1"];
            [unArchiver finishDecoding];
            
            if (model != nil) {
                [dataArray addObject:model];
                [model release];
                [unArchiver release];
            }
            
        }
        @catch (NSException *exception) {
            LXLog(@"读取收藏数据出错了");
        }
    }
    
    return dataArray;
}

/***************************持久化相关*********************************/

/**
 *  持久化数据
 *
 *  @param dataArray 需要保存的数据数组
 *  @param limit     最多保存多少个数据
 *
 *  @return 返回保存结果
 */
+ (BOOL) saveLocalListModels:(NSArray *)dataArray withLimit:(NSInteger)limit
{
    [self openLocalTable];
    
    [myDb executeUpdate:@"delete from LocalTable"];
    
    NSInteger i = 0;
    while(limit && i < dataArray.count){
        
        CategoryListModel *model = dataArray[i];
        
        @try {
            //model 数据归档
            NSMutableData *data = [NSMutableData data];
            NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:data] autorelease];
            [archiver encodeObject:model forKey:@"ListModel"];
            [archiver finishEncoding];
            
            //存储到数据库中
            BOOL result = [myDb executeUpdate:@"insert into LocalTable(recipId, data) values(?, ?)", [model.RecipeId stringValue], data];
            if (!result) {
                LXLog(@"一条数据本地保存失败\n%@", [model.RecipeId stringValue]);
            }
            else
            {
                limit--;
                LXLog(@"添加本地数据成功\n%@", [model.RecipeId stringValue]);
            }
            i++;
            
        }
        @catch (NSException *exception) {
            LXLog(@"本地数据保存失败");
            return NO;
        }
        
        
    }
    
    return YES;
}

+ (BOOL) saveLocalListModels:(NSArray *)dataArray
{
    return [self saveLocalListModels:dataArray withLimit:dataArray.count];
}


/**
 *  读取本地数据
 *
 *  @param offset 从第几条开始读起
 *  @param limit  每次读取多少条
 *
 *  @return 返回本地数据数组
 */
+ (NSArray *) readLocalListModelsWithLimit:(NSInteger)limit;
{
    [self openLocalTable];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity:2];
    
    FMResultSet *resutlSet = nil;
    resutlSet = [myDb executeQuery:@"select recipid, data from LocalTable"];
    if (resutlSet == nil)  return nil;
    
    NSInteger index = 0;
    while ([resutlSet next] && index < limit)
    {
        @try
        {
            NSMutableData *data = [resutlSet objectForColumnName:@"data"];
            
            if (data == nil)  continue;
            
            NSKeyedUnarchiver *unArchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:data] autorelease];
            CategoryListModel *model = [unArchiver decodeObjectForKey:@"ListModel"];
            [unArchiver finishDecoding];
            
            if (model != nil) {
                [dataArray addObject:model];
                index++;
            }
            
        }
        @catch (NSException *exception) {
            LXLog(@"读取本地数据出错");
        }
        
    }
    
    return dataArray;
}

+ (NSArray *) readLocalListModels
{
    
    return [self readLocalListModelsWithLimit:NSIntegerMax];
}

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
+ (BOOL) saveTempListModels:(NSArray *)dataArray fromIndex:(NSInteger)fromIndex andToIndex:(NSInteger)toIndex
{
    [self openTempTable];
    
    NSInteger maxIndex = 0;
    FMResultSet *maxSet = nil;
    maxSet = [myDb executeQuery:@"select max(listId) from TempTable"];
    if (maxSet != nil) {
        maxIndex = [maxSet intForColumn:@"listId"];
    }
    
    maxIndex += 1;
    while (fromIndex < dataArray.count && fromIndex < toIndex)
    {
        CategoryListModel *model = dataArray[fromIndex];
        
        @try {
            //归档
            NSMutableData *data = [NSMutableData data];
            NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:data] autorelease];
            [archiver encodeObject:model forKey:@"ListModel"];
            [archiver finishEncoding];
            
            if (data == nil) continue;
            
            //存储数据
            BOOL result = [myDb executeUpdate:@"insert into TempTable(listId, recipid, data), values(%d, %@, %@)", maxIndex, [model.RecipeId stringValue], data];
            
            if (result) {
                maxIndex++;
            }
            else
            {
                LXLog(@"临时数据中某条数据保存失败%@", [model.RecipeId stringValue]);
            }
            
            
        }
        @catch (NSException *exception) {
            LXLog(@"临时数据保存失败");
        }
        
        fromIndex++;
    }
    

    return NO;
}

/**
 *  读取临时数据
 *
 *  @param offset 偏移量
 *  @param limit  读取的数量
 *
 *  @return 返回临时数据数组
 */
+ (NSArray *) readTempListModelsWithOffset:(NSInteger)offset andLimit:(NSInteger)limit
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity:2];
    
    FMResultSet *resultSet = nil;
    resultSet = [myDb executeQueryWithFormat:@"select data from TempTable where listId > %ld and listId <%ld order by listId", (long)offset, (long)(offset + limit)];
    if (resultSet == nil) return dataArray;
    
    while ([resultSet next])
    {
        @try
        {
            NSMutableData *data = [resultSet objectForColumnName:@"data"];
            
            if (data == nil) continue;
            
            NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            CategoryListModel *model = [unArchiver decodeObjectForKey:@"ListModel"];
            [unArchiver finishDecoding];
            
            if (model != nil) {
                [dataArray addObject:model];
            }
            
        }
        @catch (NSException *exception) {
            LXLog(@"临时数据读取失败");
        }
    }
    
    return dataArray;
}
























@end
