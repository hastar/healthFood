//
//  DetailViewController.m
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

#import "DetailViewController.h"
#import "DetailModel.h"
#import "DetailBar.h"
#import "LXFoodNetWork.h"


#import "SubDetailView.h"
#import "CategoryListModel.h"

#import "DataBaseHandle.h"

#define kAlpha 0.9
#define kFontSize 18;
#define kImageHeaderHeight 30
#define kImageFootHeight 30
#define kLabelBeginDist 30
@interface DetailViewController () <DetailBarDelegata, UIScrollViewDelegate>

@property (nonatomic, retain)DetailBar *headerBar;
@property (nonatomic, retain)DetailModel *model;

@property (nonatomic, retain)UIImageView *backImage;
@property (nonatomic, retain)UIScrollView *scrollView;

//菜品介绍视图
@property (nonatomic, retain)SubDetailView *descView;

//食材
@property (nonatomic, retain)SubDetailView *stuffView;

//步骤
@property (nonatomic, retain)SubDetailView *stepView;

@end

@implementation DetailViewController

-(void)dealloc
{
    LXLog(@"详情页已经释放了1111");
    
    [_headerBar release];
    [_model release];
    [_backImage release];
    [_scrollView release];
    [_descView release];
    [_stuffView release];
    [_stepView release];
    [_listModel release];
    
    [super dealloc];
}


//计算文本高度
-(CGFloat)getSize:(NSString *)str
{
    CGFloat labeWidth = self.view.frame.size.width - kLabelBeginDist * 2;
    CGRect labelSize = [str boundingRectWithSize:CGSizeMake(labeWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18],NSFontAttributeName, nil] context:nil];
    return labelSize.size.height;
}

-(void)autoSetSubViewSize
{
    CGRect frame;
    //自适应食材视图
    frame = self.stuffView.frame;
    frame.origin.y = self.descView.frame.origin.y + self.descView.frame.size.height + kImageHeaderHeight;
    self.stuffView.frame = frame;
    
    //自适应步骤视图
    frame = self.stepView.frame;
    frame.origin.y = self.stuffView.frame.origin.y + self.stuffView.frame.size.height + kImageHeaderHeight;
    self.stepView.frame = frame;
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

-(void)createSubView
{
    //创建菜谱介绍
    CGRect frame = self.view.bounds;
    frame.origin.y = frame.size.height - 58;
    self.descView = [[[SubDetailView alloc] initWithFrame:frame] autorelease];
    [self.descView setViewAlpha:kAlpha];
    [self.scrollView addSubview:self.descView];
    
    //创建食材
    self.stuffView = [[[SubDetailView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0)] autorelease];
    [self.stuffView setViewAlpha:kAlpha];
    [self.scrollView addSubview:self.stuffView];
    
    //创建步骤
    self.stepView = [[[SubDetailView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0)] autorelease];
    [self.stepView setViewAlpha:kAlpha];
    [self.scrollView addSubview:self.stepView];
}

-(void)loadModelData
{
    NSData *data = [LXFoodNetWork dataWithFoodId:[self.listModel.RecipeId stringValue]];
    if (data == nil) return;
    NSDictionary *foodDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSDictionary *dic1=[foodDic objectForKey:@"result"];
    
    NSDictionary *dic2=[dic1 objectForKey:@"info"];
    self.model = [[[DetailModel alloc] init] autorelease];
    [self.model setValuesForKeysWithDictionary:dic2];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadModelData];
    self.model.coverImage = self.listModel.coverImage;
    self.view.backgroundColor = [UIColor whiteColor];
    LXLog(@"%@", self.model);
    
    CGRect frame = self.view.bounds;
    frame.origin.y += 20;
    frame.size.height -= 20;
    
    
    self.backImage = [[[UIImageView alloc] init] autorelease];
    self.backImage.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.backImage.center = CGPointMake(frame.size.width/2, frame.size.height/2 + 20);
    [self.view sendSubviewToBack:self.backImage];
    self.backImage.contentMode = UIViewContentModeScaleAspectFill;
    self.backImage.clipsToBounds = YES;
    self.backImage.image = self.model.coverImage;
    [self.view addSubview:self.backImage];
    
    
    self.scrollView = [[[UIScrollView alloc] initWithFrame:frame] autorelease];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];

    
    [self createSubView];
    [self loadSubViewData];
    [self autoSetSubViewSize];
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.stepView.frame.origin.y + self.stepView.frame.size.height + kImageFootHeight);
    
    
    
    self.headerBar = [[[DetailBar alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 55)] autorelease];
    self.headerBar.delegate = self;
    self.headerBar.contentView.alpha = 0.0;
    [self.headerBar setTitle:self.model.Title];
    [self.view addSubview:self.headerBar];
    
    
    //设置收藏按钮的状态
    [self.headerBar.collectionBtn setSelected:[DataBaseHandle isCollectWithDetailModel:self.model]];
    
    
    
    UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 120, self.view.bounds.size.width, 150)];
    headerImage.image = [UIImage imageNamed:@"detailHeader3"];
    headerImage.alpha = 0.9;
    [self.scrollView addSubview:headerImage];
    headerImage.contentMode = UIViewContentModeScaleAspectFill;
    headerImage.clipsToBounds = YES;
    [headerImage release];
    
    
}

-(void)DetailBar:(id)detailBar andBack:(id)back
{
    self.backImage.image = nil;
     [[NSNotificationCenter defaultCenter] postNotificationName:@"Refresh" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)DetailBar:(id)detailBar andCollection:(id)collection
{
    UIButton *cBtn = (UIButton *)collection;
    
    if ([cBtn isSelected]) {
        BOOL isSuccess = [DataBaseHandle deleteDetailModel:self.model];
        
        if (isSuccess)
        {
            [cBtn setSelected:NO];
        }
        
    }
    else
    {
        
        BOOL isSuccess=[DataBaseHandle collectDetailModel:self.model];
        if (isSuccess)
        {
            [cBtn setSelected:YES];
            LXLog(@"收藏成功");
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.headerBar.contentView.alpha = scrollView.contentOffset.y / self.view.frame.size.height;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
