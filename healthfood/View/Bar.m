//
//  Bar.m
//  healthfood
//
//  Created by lanou on 15/6/24.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "Bar.h"

@implementation Bar

-(void)dealloc
{
    [_contentView release];
    
    [super dealloc];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        self.contentView = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
        self.contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:200/255.0 blue:10/255.0 alpha:1.0];
        [self addSubview:self.contentView];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
