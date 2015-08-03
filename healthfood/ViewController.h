//
//  ViewController.h
//  healthfood
//
//  Created by lanou on 15/6/22.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoryModel;
@interface ViewController : UIViewController
//某个类的所有tagid
@property (nonatomic, retain) NSArray *idArray;
@property (nonatomic, retain) CategoryModel *category;
@property (nonatomic, retain) NSMutableArray *modelArray;

@end

