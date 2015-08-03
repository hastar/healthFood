//
//  LXNetWork.m
//  团购应用01
//
//  Created by lanou on 15/6/13.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "LXNetWork.h"

@interface LXNetWork () <NSURLConnectionDataDelegate>

@property (nonatomic, retain)NSMutableData *data;
@property (nonatomic, copy)resultBlock reciveBlock;
@property (nonatomic, copy)resultBlock finishBlock;

@end

@implementation LXNetWork



-(void)dealloc
{
    
    [super dealloc];
}

-(NSData *)sendSynchronousWithUrl:(NSString *)urlString andResultBlock:(resultBlock)result
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:2];
    
    NSError *err;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    
    if (err == nil) {
        result(nil);
        return nil;
    }
    
    result(data);
    return data;
}

-(void)sendAsynchronousWithUrl:(NSString *)urlString andReciveBlock:(resultBlock)reciveData andFinishData:(resultBlock)finishData
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:2];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    self.reciveBlock = reciveData;
    self.finishBlock = finishData;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.data = [[NSMutableData alloc] initWithCapacity:2];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
    self.reciveBlock(self.data);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.finishBlock(self.data);
    self.finishBlock = nil;
    self.reciveBlock = nil;
    [self.data release];
    self.data = nil;
}

/**
 *  利用同步请求urlString带参数的数据
 *
 *  @param urlString   需要请求的URL字符串
 *  @param paramString 参数字符串
 *  @param result      数据的请求结果Block
 */
-(NSData *)sendSynchronousWithUrl:(NSString *)urlString andParam:(NSString *)paramString andResultBlock:(resultBlock)result
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSError *err;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    
    if (data == nil)
    {
        result(nil);
        return nil;
    }
    
    result(data);
    return data;
}

+(void)sendASynchronousWithUrl:(NSString *)urlString andParam:(NSString *)paramString andResultBlock:(resultBlock)result
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError != nil) {
            result(nil);
        }
        else
        {
            result(data);            
        }
        
    }];

}









@end
