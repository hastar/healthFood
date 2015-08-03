//
//  CollectionBar.m
//  healthfood
//
//  Created by lanou on 15/6/24.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "CollectionBar.h"

@interface CollectionBar ()

@property (nonatomic, retain)UIButton *backBtn;
@property (nonatomic, retain) UIButton *deleteBtn;

@end

@implementation CollectionBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat subHeight = frame.size.height;
        self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backBtn.frame = CGRectMake(15, 0, subHeight, subHeight);
        [self.backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [self.backBtn addTarget:self action:@selector(doOpition:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.backBtn];
        
        
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteBtn.frame = CGRectMake(frame.size.width - subHeight  - 10, 0, subHeight, subHeight);
        [self.deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [self.deleteBtn addTarget:self action:@selector(doDelete:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.deleteBtn];
        
    }
    return self;
}

-(void)doOpition:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(CollectionBar:andBack:)]) {
        [self.delegate CollectionBar:self andBack:sender];
    }
}

-(void)doDelete:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(CollectionBar:andOpition:)]) {
        [self.delegate CollectionBar:self andOpition:sender];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
