//
//  OpitionTableViewCell.h
//  healthfood
//
//  Created by lanou on 15/6/24.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface OpitionTableViewCell : UITableViewCell

@property (nonatomic, retain) UIImageView *photoImage;
@property (nonatomic, retain) UILabel *titleLabel;

-(void) setAccessoryText:(NSString *)text;

@end
