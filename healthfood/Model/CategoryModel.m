//
//  CategoryModel.m
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

#import "CategoryModel.h"

@implementation CategoryModel

-(void)dealloc
{
    LXLog(@"categoryModel 已经释放了");
    [_title release];
    [_image release];
    [_idArray release];
    
    [super dealloc];
}

-(instancetype)initWithTitle:(NSString *)title andImageName:(NSString *)imageName andIdArray:(NSArray *)array
{
    if (self = [super init]) {
        self.title = title;
        self.image = [UIImage imageNamed:imageName];
        self.idArray = [NSArray arrayWithArray:array];
    }
    
    return self;
}

@end
