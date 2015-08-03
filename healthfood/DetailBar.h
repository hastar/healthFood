//
//  DetailBar.h
//  healthfood
//
//  Created by lanou on 15/6/24.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "Bar.h"

@protocol DetailBarDelegata <NSObject>

@required
-(void)DetailBar:(id)detailBar andBack:(id)back;
-(void)DetailBar:(id)detailBar andCollection:(id)collection;

@end

@interface DetailBar : Bar

@property (nonatomic, retain)UIButton *collectionBtn;
@property (nonatomic, assign)id<DetailBarDelegata> delegate;


-(void)setTitle:(NSString *)title;


@end
