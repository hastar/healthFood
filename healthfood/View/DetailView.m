//
//  DetailView.m
//  healthfood
//
//  Created by lanou on 15/6/26.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#ifdef DEBUG
#define LXLog(...) NSLog(__VA_ARGS__)
#else
#define LXLog(...)
#endif

#import "DetailView.h"
#import "DetailModel.h"
#import "SubDetailView.h"
#import "UIImageView+WebCache.h"

#define kAlpha 0.9
@interface DetailView () <UIScrollViewDelegate>

@property (nonatomic, retain)UIImageView *backImageView;

//菜品介绍视图
@property (nonatomic, retain)SubDetailView *descView;

//食材
@property (nonatomic, retain)SubDetailView *stuffView;

//步骤
@property (nonatomic, retain)SubDetailView *stepView;

@end

@implementation DetailView

-(void)dealloc
{
    LXLog(@"子详情页面已经释放");
    [_backImageView release];
    [_descView release];
    [_stuffView release];
    [_stepView release];
    [_model release];
    [_scrollView release];
    
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        CGRect myFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.scrollView = [[[UIScrollView alloc] initWithFrame:myFrame] autorelease];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.delegate = self;
        self.scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        
        //创建菜谱介绍
        CGRect frame = self.bounds;
        frame.origin.y = frame.size.height - 33;
        self.descView = [[[SubDetailView alloc] initWithFrame:frame] autorelease];
        [self.descView setViewAlpha:kAlpha];
        [self.descView setHeaderImageHidden:YES];
        [self.scrollView addSubview:self.descView];
        
        //创建食材
        self.stuffView = [[[SubDetailView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0)] autorelease ];
        [self.stuffView setViewAlpha:kAlpha];
        [self.scrollView addSubview:self.stuffView];
        
        //创建步骤
        self.stepView = [[[SubDetailView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0)] autorelease];
        [self.stepView setViewAlpha:kAlpha];
        [self.scrollView addSubview:self.stepView];
        
        UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 95, self.bounds.size.width, 150)];
        headerImage.image = [UIImage imageNamed:@"detailHeader3"];
        headerImage.alpha = 0.9;
        [self.scrollView addSubview:headerImage];
        headerImage.contentMode = UIViewContentModeScaleAspectFill;
        headerImage.clipsToBounds = YES;
        [headerImage release];
              
        
        self.backImageView = [[[UIImageView alloc] init] autorelease];
        self.backImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.backImageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addSubview:self.backImageView];
        [self sendSubviewToBack:self.backImageView];
        self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backImageView.clipsToBounds = YES;
        
        
    }
    return self;
}

-(void)setBackImage:(UIImage *)backImage
{
    if (backImage != nil) {
        [self setImage:backImage];
    }
    
}

-(void)setImage:(UIImage *)image
{

    self.backImageView.image = image;

}

-(void)setModel:(DetailModel *)model
{
    if (model == nil) {
        return ;
    }
    
    
    _model = [model retain];

    NSURL *url = [NSURL URLWithString:model.Cover];
    [self.backImageView sd_setImageWithURL:url];
    
    [self loadSubViewData];
    [self autoSetSubViewSize];
    
}

-(void)autoSetSubViewSize
{
    CGRect frame;
    //自适应食材视图
    frame = self.stuffView.frame;
    frame.origin.y = self.descView.frame.origin.y + self.descView.frame.size.height + 20;
    self.stuffView.frame = frame;
    
    //自适应步骤视图
    frame = self.stepView.frame;
    frame.origin.y = self.stuffView.frame.origin.y + self.stuffView.frame.size.height + 20;
    self.stepView.frame = frame;
    
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width, frame.size.height + frame.origin.y + 10);
}



-(void)loadSubViewData
{
    //设置介绍文本
    NSMutableString *str = [[NSMutableString alloc] initWithString:@"     "];
    if (self.model.Intro.length > 100) {
        [str appendString:[self.model.Intro substringToIndex:100]];
    }
    else
    {
        [str appendString:self.model.Intro];
    }
    [self.descView setMainText:str];
    [str release];
    
    //设置食材数据
    NSMutableString *mString = [[NSMutableString alloc] initWithString:@"主料\r\n"];
    for (NSDictionary *stu in self.model.MainStuff) {
        [mString appendString:stu[@"name"]];
        [mString appendString:@":"];
        [mString appendString:stu[@"weight"]];
        [mString appendString:@"\r\n"];
    }
    [self.stuffView setMainText:mString];
    [mString release];
    
    NSMutableString *oString = [[NSMutableString alloc] initWithString:@"配料\r\n"];
    for (NSDictionary *stu in self.model.OtherStuff) {
        [oString appendString:stu[@"name"] ];
        [oString appendString:@":"];
        [oString appendString:stu[@"weight"]];
        [oString appendString:@"\r\n"];
    }
    [self.stuffView setSubText:oString];
    [self.stuffView setLabelAlignment:NSTextAlignmentCenter];
    [oString release];
    
    //设置步骤数据
    int i = 1;
    NSMutableString *stepString = [[NSMutableString alloc] init];
    for (NSDictionary *step in self.model.Steps) {
        [stepString appendFormat:@"%d、", i];
        [stepString appendString:step[@"Intro"]];
        [stepString appendString:@"\r\n"];
        i++;
    }
    [self.stepView setMainText:stepString];
    [stepString release];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.delegate DetailView:self andScrollView:scrollView];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"coverImage"]) {
        LXLog(@"图片加载完成");
        [self setImage:self.model.coverImage];
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
