//
//  CategoryModel.h
//  healthfood
//
//  Created by lanou on 15/6/22.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CategoryModel : NSObject


@property (nonatomic, retain)NSString *title;
@property (nonatomic, retain)UIImage *image;
@property (nonatomic, retain)NSArray *idArray;

-(instancetype)initWithTitle:(NSString *)title andImageName:(NSString *)imageName andIdArray:(NSArray *)array;

@end
