//
//  DetailBar.m
//  healthfood
//
//  Created by lanou on 15/6/24.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "DetailBar.h"

@interface DetailBar ()

@property (nonatomic, retain)UILabel *titleLabel;
@property (nonatomic, retain)UIButton *backBtn;

@end


@implementation DetailBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat subHeight = frame.size.height;
        CGFloat subWidth = frame.size.width;
        self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backBtn.frame = CGRectMake(15, 0, subHeight, subHeight);
        [self.backBtn setBackgroundImage:[UIImage imageNamed:@"back2"] forState:UIControlStateNormal];
        [self.backBtn addTarget:self action:@selector(doOpition:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.backBtn];
        
        self.collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.collectionBtn.frame = CGRectMake(subWidth - subHeight, subHeight/4, subHeight/2, subHeight/2);
        [self.collectionBtn setBackgroundImage:[UIImage imageNamed:@"collect1"] forState:UIControlStateNormal];
        [self.collectionBtn setBackgroundImage:[UIImage imageNamed:@"collect_light1"] forState:UIControlStateSelected];
        
        [self.collectionBtn addTarget:self action:@selector(doCollection:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.collectionBtn];
        
    
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(subHeight + 20, 0, subWidth - subHeight * 3, subHeight)] autorelease];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.titleLabel setTextColor:[UIColor whiteColor]];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [self addSubview:self.titleLabel];
        
    }
    return self;
}

-(void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

-(void)doOpition:(id)sender
{
    
    [self.delegate DetailBar:self andBack:sender];
}

-(void)doCollection:(UIButton *)sender
{    
    [self.delegate DetailBar:self andCollection:sender];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
