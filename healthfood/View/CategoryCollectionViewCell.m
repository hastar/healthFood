//
//  CategoryCollectionViewCell.m
//  Waterflow
//
//  Created by lanou on 15/6/20.
//  Copyright (c) 2015年 yangjw . All rights reserved.
//
#ifdef DEBUG
#define LXLog(...) NSLog(__VA_ARGS__)
#else
#define LXLog(...)
#endif

#import "CategoryCollectionViewCell.h"

@implementation CategoryCollectionViewCell

-(void)dealloc
{
    [_imageView1 release];
    [_label release];
    
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.imageView1=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)] autorelease];
        self.imageView1.backgroundColor=[UIColor redColor];
        self.imageView1.layer.cornerRadius = frame.size.width/2;
        self.imageView1.layer.borderWidth = 2;
        self.imageView1.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.imageView1.layer.masksToBounds = YES;
        [self.contentView addSubview:self.imageView1];
        
        self.label=[[[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.width+10, frame.size.width, 20)] autorelease];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.label];        
        
    }
    
    return self;
}

@end
