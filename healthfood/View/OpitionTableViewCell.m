//
//  OpitionTableViewCell.m
//  healthfood
//
//  Created by lanou on 15/6/24.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#ifdef DEBUG
#define LXLog(...) NSLog(__VA_ARGS__)
#else
#define LXLog(...)
#endif

#import "OpitionTableViewCell.h"

@interface OpitionTableViewCell ()

@property (nonatomic, retain) UILabel *accessoryLabel;

@end

@implementation OpitionTableViewCell

-(void)dealloc
{
    [_photoImage release];
    [_titleLabel release];
    
    [super dealloc];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.photoImage = [[[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 30, 30)] autorelease];
        [self.photoImage setClipsToBounds:YES];
        [self.photoImage setContentMode:UIViewContentModeScaleAspectFit];
        [self.contentView addSubview:self.photoImage];
        
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(70, 0, 80, 40)] autorelease];
        [self.titleLabel setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:self.titleLabel];
        
        
        self.accessoryLabel = [[[UILabel alloc]initWithFrame:CGRectMake(150, 0, 80, 40)] autorelease];
        [self.accessoryLabel setTextColor:[UIColor grayColor]];
        self.accessoryLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.accessoryLabel];
        
    }
    
    return self;
}

-(void)setAccessoryText:(NSString *)text
{
    self.accessoryLabel.text = text;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    // Configure the view for the selected state
}

@end
