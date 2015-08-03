//
//  CategoryListModel.h
//  healthfood
//
//  Created by lanou on 15/6/22.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CategoryListModel : NSObject <NSCoding>


@property (nonatomic, retain) NSString *Collection;
@property (nonatomic, retain) NSString *Cover;
@property (nonatomic, retain) NSNumber *FavoriteCount;
@property (nonatomic, retain) NSNumber *HasVideo;
@property (nonatomic, retain) NSNumber *RecipeId;
@property (nonatomic, retain) NSString *Stuff;
@property (nonatomic, retain) NSString *Title;
@property (nonatomic, retain) NSNumber *ViewCount;

@property (nonatomic, strong) UIImage *coverImage;

@end
