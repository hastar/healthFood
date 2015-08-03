//
//  CollectionBar.h
//  healthfood
//
//  Created by lanou on 15/6/24.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bar.h"

@protocol CollectionBarDelegate <NSObject>

-(void)CollectionBar:(id)collectionBar andBack:(UIButton *)back;
-(void)CollectionBar:(id)collectionBar andOpition:(UIButton *)opition;

@end

@interface CollectionBar : Bar

@property (nonatomic, assign)id<CollectionBarDelegate> delegate;

@end
