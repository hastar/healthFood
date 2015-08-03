//
//  MyCollectionViewCell.m
//  CollectionDemo
//
//  Created by lanou on 15/7/8.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "MyCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface MyCollectionViewCell ()

@property (assign, nonatomic) IBOutlet UIImageView *photoView;
@property (assign, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MyCollectionViewCell


-(void)prepareForReuse
{
    
    self.photoView.image = nil;
}

-(void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

-(void)setImageUrl:(NSString *)imageUrl
{
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

- (void)awakeFromNib {
    // Initialization code
    
    self.titleLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    self.photoView.contentMode = UIViewContentModeScaleAspectFill;
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
}

@end
