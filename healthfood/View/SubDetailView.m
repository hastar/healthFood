//
//  SubDetailView.m
//  healthfood
//
//  Created by lanou on 15/6/24.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "SubDetailView.h"

#define kLabelBeginDist 30

@interface SubDetailView ()
@property (nonatomic, retain)UIImageView *beforeImage;
@property (nonatomic, retain)UIImageView *nextImage;
@property (nonatomic, retain)UIImageView *contentImage;

@property (nonatomic, retain)UILabel *mainLabel;
@property (nonatomic, retain)UILabel *subLabel;

@end

@implementation SubDetailView

//计算文本高度
-(CGFloat)getSize:(NSString *)str
{
    CGFloat labeWidth = self.frame.size.width - kLabelBeginDist * 2;
    CGRect labelSize = [str boundingRectWithSize:CGSizeMake(labeWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18],NSFontAttributeName, nil] context:nil];
    return labelSize.size.height;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.beforeImage = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)] autorelease];;
        self.beforeImage.image = [UIImage imageNamed:@"bolang1"];
        [self addSubview:self.beforeImage];
        
        self.contentImage = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 30, frame.size.width, 0)] autorelease];
        self.contentImage.image = [UIImage imageNamed:@"bolang2"];
        [self addSubview:self.contentImage];
        
        self.nextImage = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)] autorelease];
        self.nextImage.image = [UIImage imageNamed:@"bolang3"];
        [self addSubview:self.nextImage];
        
        self.mainLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.mainLabel.numberOfLines = 0;
        [self.contentImage addSubview:self.mainLabel];
        
        self.subLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.subLabel.numberOfLines = 0;
        [self.contentImage addSubview: self.subLabel];
        
        
        
    }
    return self;
}

-(void)autoSetViewSize
{
    //自适应mainLabel 的高度
    CGRect frame = self.mainLabel.frame;
    frame.origin = CGPointMake(kLabelBeginDist, 10);
    CGFloat height = [self getSize:self.mainLabel.text];
    frame.size = CGSizeMake(self.bounds.size.width - kLabelBeginDist * 2, height);
    self.mainLabel.frame = frame;
    
    //自适应subLabel 的高度
    height = self.mainLabel.frame.origin.y + self.mainLabel.frame.size.height;
    frame.origin = CGPointMake(kLabelBeginDist, height + 10);
    height = [self getSize:self.subLabel.text];
    frame.size = CGSizeMake(self.bounds.size.width - kLabelBeginDist * 2, height);
    self.subLabel.frame = frame;
    
    //自适应contentImage
//    CGFloat y = self.beforeImage.frame.origin.y + self.beforeImage.frame.size.height;
    height = self.subLabel.frame.origin.y + self.subLabel.frame.size.height + 10;
    frame = self.contentImage.frame;
    frame.size.height = height;
//    frame.origin.y = y;
    self.contentImage.frame = frame;
    
    //自适应nextImage
    frame = self.nextImage.frame;
    frame.origin.y = self.contentImage.frame.origin.y + self.contentImage.frame.size.height - 0;
    self.nextImage.frame = frame;
    
    frame = self.frame;
    frame.size.height = self.nextImage.frame.origin.y + self.nextImage.frame.size.height + 5;
    self.frame = frame;
}

-(void)setMainText:(NSString *)text
{
    self.mainLabel.text = text;
    [self autoSetViewSize];
}

-(void)setSubText:(NSString *)text
{
    self.subLabel.text = text;
    [self autoSetViewSize];
}

-(void)setViewAlpha:(CGFloat)alpha
{
    self.beforeImage.alpha = alpha;
    self.contentImage.alpha = alpha;
    self.nextImage.alpha = alpha;
}


-(void)setLabelAlignment:(NSTextAlignment)alignment
{
    self.mainLabel.textAlignment = alignment;
    self.subLabel.textAlignment = alignment;
}

-(void)setHeaderImageHidden:(BOOL)hidden
{
    if (hidden != YES)
    {
        CGRect frame = self.beforeImage.frame;
        frame.size.height = 0;
        self.beforeImage.frame = frame;
        self.beforeImage.hidden = hidden;
        
        [self autoSetViewSize];
    }
    else
    {
        CGRect frame = self.beforeImage.frame;
        frame.size.height = 50;
        self.beforeImage.frame = frame;
        self.beforeImage.hidden = hidden;
        
        [self autoSetViewSize];

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
