//
//  DetailModel.m
//  healthfood
//
//  Created by lanou on 15/6/24.
//  Copyright (c) 2015年 hastar. All rights reserved.
//
#ifdef DEBUG
#define LXLog(...) NSLog(__VA_ARGS__)
#else
#define LXLog(...)
#endif


#import "DetailModel.h"
#import "LXNetWork.h"

@implementation DetailModel


-(void)dealloc
{
    LXLog(@"详情Model释放完毕");
    [_Collection release];
    [_CommentCount release];
    [_CookTime release];
    [_Cover release];
    [_FavoriteCount release];
    [_Intro release];
    [_MainStuff release];
    [_OtherStuff release];
    [_ReadyTime release];
    [_Steps release];
    [_Title release];
    [_Tips release];
    [_RecipeId release];
    [_UserName release];
    [_UserCount release];
    [_coverImage release];
    
    
    [super dealloc];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}


#pragma -mark nscodring的协议方法
//将一个对象通过编码的方式 转化为NSData（亚索=压缩）
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    //
    [aCoder encodeObject:self.Collection forKey:@"Collection"];
    
    [aCoder encodeObject:self.CommentCount forKey:@"CommentCount"];
    [aCoder encodeObject:self.CookTime forKey:@"CookTime"];
    [aCoder encodeObject:self.Cover forKey:@"Cover"];
    [aCoder encodeObject:self.FavoriteCount forKey:@"FavoriteCount"];
    [aCoder encodeObject:self.Intro forKey:@"Intro"];
    [aCoder encodeObject:self.MainStuff forKey:@"MainStuff"];
    [aCoder encodeObject:self.OtherStuff forKey:@"OtherStuff"];
    [aCoder encodeObject:self.ReadyTime forKey:@"ReadyTime"];
    [aCoder encodeObject:self.ReviewTime forKey:@"ReviewTime"];
    [aCoder encodeObject:self.Steps forKey:@"Steps"];
    [aCoder encodeObject:self.Tips forKey:@"Tips"];
    [aCoder encodeObject:self.Title forKey:@"Title"];
    [aCoder encodeObject:self.RecipeId forKey:@"RecipeId"];
    [aCoder encodeObject:self.coverImage forKey:@"coverImage"];
    
    
}


//用一个NSData创建一个对象（解压）
-(id)initWithCoder:(NSCoder *)aDecoder
{   //初始化方法
    if (self = [super init])
    {
        self.RecipeId = [aDecoder decodeObjectForKey:@"RecipeId"];
        self.Collection = [aDecoder decodeObjectForKey:@"Collection"];
        self.CommentCount=[aDecoder decodeObjectForKey:@"CommentCount"];
        self.CookTime = [aDecoder decodeObjectForKey:@"CookTime"];
        self.Cover = [aDecoder decodeObjectForKey:@"Cover"];
        self.FavoriteCount = [aDecoder decodeObjectForKey:@"FavoriteCount"];
        self.Intro = [aDecoder decodeObjectForKey:@"Intro"];
        self.MainStuff = [aDecoder decodeObjectForKey:@"MainStuff"];
        self.OtherStuff = [aDecoder decodeObjectForKey:@"OtherStuff"];
        self.ReadyTime = [aDecoder decodeObjectForKey:@"ReadyTime"];
        self.ReviewTime = [aDecoder decodeObjectForKey:@"ReviewTime"];
        self.Steps = [aDecoder decodeObjectForKey:@"Steps"];
        self.Tips = [aDecoder decodeObjectForKey:@"Tips"];
        self.Title = [aDecoder decodeObjectForKey:@"Title"];
        self.coverImage = [aDecoder decodeObjectForKey:@"coverImage"];
        
    }
    return self;
    
}

//-(void)setCover:(NSString *)Cover
//{
//    _Cover = [Cover retain];
//    NSData *data = [[LXNetWork alloc] sendSynchronousWithUrl:_Cover andResultBlock:^(NSData *resultData) {
//        
//    }];
//    
//    if (data == nil) {
//        LXLog(@"图片加载出错");
//        
//        [[LXNetWork alloc] sendSynchronousWithUrl:_Cover andResultBlock:^(NSData *resultData) {
//            self.coverImage = [[[UIImage alloc] initWithData:resultData] autorelease];
//            LXLog(@"图片加载完成");
//        }];
//    }
//    else
//    {
//        LXLog(@"图片加载完成");
//        self.coverImage = [[[UIImage alloc] initWithData:data] autorelease];
//    }
//    
//}


@end
