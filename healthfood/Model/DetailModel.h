//
//  DetailModel.h
//  healthfood
//
//  Created by lanou on 15/6/24.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DetailModel : NSObject <NSCoding>


@property (nonatomic, retain) NSString *Collection;//喜欢和浏览量
@property (nonatomic, retain) NSNumber *CommentCount;//评论数量
@property (nonatomic, retain) NSString *CookTime;//烹饪所需要的时间

@property (nonatomic, retain) NSString *Cover;//封面图片URL

@property (nonatomic, retain) NSNumber *FavoriteCount;//喜爱的人数
@property (nonatomic, retain) NSString *Intro;//菜品简介
@property (nonatomic, retain) NSArray *MainStuff;//主要食材
@property (nonatomic, retain) NSArray *OtherStuff;//其他食材
@property (nonatomic, retain) NSString *ReadyTime;//准备所需时间
@property (nonatomic, retain) NSString *ReviewTime;//发布时间
@property (nonatomic, retain) NSArray *Steps;//主要步骤
@property (nonatomic, retain) NSString *Tips;//小贴士
@property (nonatomic, retain) NSString *Title;//菜品名称
@property (nonatomic, retain) NSNumber *RecipeId;//菜品ID
@property (nonatomic, retain) NSString *UserName;//发布者名称
@property (nonatomic, retain) NSString *UserCount;//用餐人数


@property (nonatomic, copy) UIImage *coverImage;//请求出来的图片


@end
