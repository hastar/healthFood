//
//  LXNetWork.h
//  团购应用01
//
//  Created by lanou on 15/6/13.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^resultBlock)(NSData *resultData);

@interface LXNetWork : NSObject

/**
 *  利用同步请求urlString的数据
 *
 *  @param urlString 需要请求的URL字符串
 *  @param result    数据的请求结果Block
 */
-(NSData *)sendSynchronousWithUrl:(NSString *)urlString andResultBlock:(resultBlock) result;

/**
 *  利用异步请求urlString数据
 *
 *  @param urlString  需要请求的URL字符串
 *  @param reciveData 异步数据的接收Block
 *  @param finishData 当整个数据接收完后调用的Block
 */
-(void)sendAsynchronousWithUrl:(NSString *)urlString andReciveBlock:(resultBlock)reciveData andFinishData:(resultBlock)finishData;

/**
 *  利用同步请求urlString带参数的数据
 *
 *  @param urlString   需要请求的URL字符串
 *  @param paramString 参数字符串
 *  @param result      数据的请求结果Block
 */
-(NSData *)sendSynchronousWithUrl:(NSString *)urlString andParam:(NSString *)paramString andResultBlock:(resultBlock)result;

/**
 *  利用异步POST方式请求网络数据
 *
 *  @param urlString   需要请求的URL字符串
 *  @param paramString 参数字符串
 *  @param result      数据的请求结果Block
 */
+(void)sendASynchronousWithUrl:(NSString *)urlString andParam:(NSString *)paramString andResultBlock:(resultBlock)result;

@end
