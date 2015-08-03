//
//  DetailView.h
//  healthfood
//
//  Created by lanou on 15/6/26.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailViewDelegate <NSObject>

-(void)DetailView:(id)detailView andScrollView:(id)scrollView;

@end

@class DetailModel;
@interface DetailView : UIView

@property (nonatomic, retain) DetailModel *model;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, assign) id<DetailViewDelegate> delegate;

-(void) setBackImage:(UIImage *)backImage;

@end
