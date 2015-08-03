//
//  CategoryListModel.m
//  healthfood
//
//  Created by lanou on 15/6/22.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#ifdef DEBUG
#define LXLog(...) NSLog(__VA_ARGS__)
#else
#define LXLog(...)
#endif

#import "CategoryListModel.h"
#import "LXNetWork.h"
#import "UIImageView+WebCache.h"


@implementation CategoryListModel

-(void)dealloc
{
    LXLog(@"categoryListModel 已经释放了");
    [_Collection release];
    [_Cover release];
    [_FavoriteCount release];
    [_HasVideo release];
    [_RecipeId release];
    [_Stuff release];
    [_Title release];
    [_ViewCount release];
    
    [_coverImage release];
    
    [super dealloc];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}

-(void)setCover:(NSString *)Cover
{
    _Cover = [[NSString alloc] initWithString:[Cover stringByReplacingOccurrencesOfString:@"g_230" withString:@"l"]];
    
    if (self.coverImage != nil) {
        LXLog(@"图片已经有了");
    }
    
    NSData *data = [[LXNetWork alloc] sendSynchronousWithUrl:_Cover andResultBlock:^(NSData *resultData) {
        
    }];
    
    if (data == nil) {
        LXLog(@"图片加载出错");
        [[LXNetWork alloc] sendSynchronousWithUrl:_Cover andResultBlock:^(NSData *resultData) {
            self.coverImage = [[[UIImage alloc] initWithData:resultData] autorelease];
        }];
    }
    else
    {
        self.coverImage = [[[UIImage alloc] initWithData:data] autorelease];
        
#warning SDWebImage请求图片
        NSURL *url = [NSURL URLWithString:_Cover];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [[manager imageCache] storeImage:self.coverImage forKey:url.absoluteString];
        [[manager imageCache] removeImageForKey:url.absoluteString fromDisk:NO];
    }
    
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:self.Collection forKey:@"Collection"];
    [aCoder encodeObject:self.coverImage forKey:@"coverImage"];
    [aCoder encodeObject:self.FavoriteCount forKey:@"FavoriteCount"];
    [aCoder encodeObject:self.HasVideo forKey:@"HasVideo"];
    [aCoder encodeObject:self.RecipeId forKey:@"RecipeId"];
    [aCoder encodeObject:self.Stuff forKey:@"Stuff"];
    [aCoder encodeObject:self.Title forKey:@"Title"];
    [aCoder encodeObject:self.ViewCount forKey:@"ViewCount"];
    [aCoder encodeObject:self.Cover forKey:@"Cover"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{

    
    if (self = [super init])
    {
        self.Collection = [aDecoder decodeObjectForKey:@"Collection"];
        self.coverImage = [aDecoder decodeObjectForKey:@"coverImage"];
        self.FavoriteCount = [aDecoder decodeObjectForKey:@"FavoriteCount"];
        self.HasVideo = [aDecoder decodeObjectForKey:@"HasVideo"];
        self.RecipeId = [aDecoder decodeObjectForKey:@"RecipeId"];
        self.Stuff = [aDecoder decodeObjectForKey:@"Stuff"];
        self.Title = [aDecoder decodeObjectForKey:@"Title"];
        self.ViewCount = [aDecoder decodeObjectForKey:@"ViewCount"];
        self.Cover = [aDecoder decodeObjectForKey:@"Cover"];
    }

    return self;
    
}



@end
