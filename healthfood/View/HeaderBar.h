//
//  HeaderBar.h
//  healthfood
//
//  Created by lanou on 15/6/23.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bar.h"

@protocol HeaderBarDelegate <NSObject>

@required
-(void)headerBar:(id)headerBar andOption:(UIButton *)opition;
-(void)headerBar:(id)headerBar andCategory:(UIButton *)category;
-(void)headerBar:(id)headerBar andSearchText:(NSString *)searchText;
-(void)headerBarBeginSearch;
-(void)headerBarEndSearch;

@end

@interface HeaderBar : Bar

@property (nonatomic, assign)id<HeaderBarDelegate> delegate;

-(void)setTitle:(NSString *)title;

@end
