//
//  DetailAllViewController.m
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


#import "DetailAllViewController.h"
#import "CategoryListModel.h"
#import "LXFoodNetWork.h"
#import "DetailView.h"
#import "DetailModel.h"
#import "DetailBar.h"
#import "Reachability.h"
#import "AFNetworking.h"

#import "DataBaseHandle.h"

@interface DetailAllViewController () <UIScrollViewDelegate, DetailBarDelegata, DetailViewDelegate>

//model数据
@property (nonatomic, retain) DetailModel *beforeModel;
@property (nonatomic, retain) DetailModel *curModel;
@property (nonatomic, retain) DetailModel *nextModel;

@property (nonatomic, retain) DetailView *beforeView;
@property (nonatomic, retain) DetailView *curView;
@property (nonatomic, retain) DetailView *nextView;

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) DetailBar *headerBar;

@end

@implementation DetailAllViewController



-(void)dealloc
{
    LXLog(@"--详情已经释放");
    [_beforeModel release];
    [_curModel release];
    [_nextModel release];
    
    [_beforeView release];
    [_curView release];
    [_nextView release];
    
    [_scrollView release];
    [_headerBar release];
    
    [_listArray release];
    
    [super dealloc];
}

#pragma mark - 数据加载
#pragma mark - 加载前一个菜品model数据
-(void)loadBeforeModel
{
    if (![[AFNetworkReachabilityManager sharedManager] isReachable])
    {
        return ;
    }
    
    if (self.curIndex <= 0) {
        return;
    }
    
    CategoryListModel *mList = self.listArray[self.curIndex - 1];
    NSString *strId = [mList.RecipeId stringValue];
    [self.beforeView setBackImage:mList.coverImage];
    
    __block DetailAllViewController *weakSelf = self;
    [LXFoodNetWork dataWithFoodId:strId andBlock:^(NSData *resultData)
    {
        if (resultData != nil)
        {
            NSDictionary *foodDic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            
            NSDictionary *dic1=[foodDic objectForKey:@"result"];
            NSDictionary *dic2=[dic1 objectForKey:@"info"];
            weakSelf.beforeModel = [[[DetailModel alloc] init] autorelease];
            [weakSelf.beforeModel setValuesForKeysWithDictionary:dic2];
            weakSelf.beforeModel.coverImage = mList.coverImage;
            weakSelf.beforeView.model = weakSelf.beforeModel;
        }
        else
        {
            [weakSelf loadBeforeModel];
        }

    }];
}

#pragma mark 加载下一个菜品model数据
-(void)loadNextModel
{
    if (![[AFNetworkReachabilityManager sharedManager] isReachable])
    {
        return ;
    }
    
    if (self.curIndex >= self.listArray.count-1) {
        return;
    }
    
    CategoryListModel *mList = self.listArray[self.curIndex + 1];
    NSString *strId = [mList.RecipeId stringValue];
    [self.nextView setBackImage:mList.coverImage];
    
    __block DetailAllViewController *weakSelf = self;
    [LXFoodNetWork dataWithFoodId:strId andBlock:^(NSData *resultData)
     {
         if (resultData != nil)
         {
             NSDictionary *foodDic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
             
             NSDictionary *dic1=[foodDic objectForKey:@"result"];
             NSDictionary *dic2=[dic1 objectForKey:@"info"];
             weakSelf.nextModel = [[[DetailModel alloc] init] autorelease];
             [weakSelf.nextModel setValuesForKeysWithDictionary:dic2];
             weakSelf.nextModel.coverImage = mList.coverImage;
             weakSelf.nextView.model = weakSelf.nextModel;

         }
         else
         {
             [weakSelf loadNextModel];
         }
         
    }];
}

#pragma mark 加载当前显示的model数据
-(void)loadCurModel
{
    if (![[AFNetworkReachabilityManager sharedManager] isReachable])
    {
        return ;
    }
    
    
    if (self.curIndex >= self.listArray.count || self.curIndex < 0) {
        return;
    }
    
    CategoryListModel *mList = self.listArray[self.curIndex];
    NSString *strId = [mList.RecipeId stringValue];
    [self.curView setBackImage:mList.coverImage];
    [self.headerBar.collectionBtn setSelected:[DataBaseHandle isCollectWithModelRecipId:strId]];
    
    __block DetailAllViewController *weakSelf = self;
    [LXFoodNetWork dataWithFoodId:strId andBlock:^(NSData *resultData)
     {
         if (resultData != nil)
         {
             NSDictionary *foodDic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
             
             NSDictionary *dic1=[foodDic objectForKey:@"result"];
             NSDictionary *dic2=[dic1 objectForKey:@"info"];
             weakSelf.curModel = [[[DetailModel alloc] init] autorelease];
             [weakSelf.curModel setValuesForKeysWithDictionary:dic2];
             if (weakSelf.curModel.coverImage == nil) {
                 weakSelf.curModel.coverImage = mList.coverImage;
             }
             weakSelf.curView.model = weakSelf.curModel;
             [weakSelf.headerBar setTitle:weakSelf.curModel.Title];
            [weakSelf.headerBar.collectionBtn setSelected:[DataBaseHandle isCollectWithDetailModel:self.curModel]];
         }
         else
         {
             [weakSelf loadCurModel];
         }

     }];
}

#pragma mark 系统viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGRect frame = self.view.bounds;
    frame.origin.y = 20;
    self.scrollView = [[[UIScrollView alloc] initWithFrame:frame] autorelease];
    self.scrollView.delegate = self;
    [self.view addSubview: self.scrollView];
    
    
    frame = self.view.bounds;
    frame.size.height -= 20;
    self.beforeView = [[[DetailView alloc] initWithFrame:frame] autorelease];
    self.beforeView.delegate = self;
    [self.scrollView addSubview:self.beforeView];
    
    frame.origin.x = frame.size.width;
    self.curView = [[[DetailView alloc] initWithFrame:frame] autorelease];
    self.curView.delegate = self;
    [self.scrollView addSubview:self.curView];

    frame.origin.x = frame.size.width * 2;
    self.nextView = [[[DetailView alloc] initWithFrame:frame] autorelease];
    self.nextView.delegate = self;
    [self.scrollView addSubview:self.nextView];
    
    CGPoint offset;
    if (self.curIndex == 0) {
        self.curIndex += 1;
        offset = CGPointMake(0, 0);
    }
    else if (self.curIndex == self.listArray.count-1)
    {
        self.curIndex -= 1;
        offset = CGPointMake(frame.size.width * 2, 0);
    }else
    {
         offset = CGPointMake(frame.size.width, 0);
    }
    
    self.scrollView.contentSize = CGSizeMake(frame.size.width * 3 , frame.size.height-20);
    self.scrollView.bounces = YES;
    self.scrollView.contentOffset = offset;
    self.scrollView.pagingEnabled = YES;
    
    
    [self loadCurModel];
    [self loadNextModel];
    [self loadBeforeModel];
    
    self.headerBar = [[[DetailBar alloc] initWithFrame:CGRectMake(0, 20, frame.size.width, 55)] autorelease];
    self.headerBar.delegate = self;
    self.headerBar.contentView.alpha = 0.f;
    [self.headerBar setTitle:self.curModel.Title];
    BOOL state = [DataBaseHandle isCollectWithDetailModel:self.curModel];
    [self.headerBar.collectionBtn setSelected:state];
    
    [self.view addSubview:self.headerBar];
    
}

#pragma mark - 导航栏
#pragma mark - 导航栏 收藏按钮
-(void)DetailBar:(id)detailBar andCollection:(id)collection
{
    UIButton *cBtn = (UIButton *)collection;
    
    if ([cBtn isSelected])
    {
        
        BOOL isSuccess=[DataBaseHandle deleteDetailModel:self.curModel];
        
        if (isSuccess)
        {
            [cBtn setSelected:NO];
        }
    }
    else
    {
        BOOL isSuccess= [DataBaseHandle collectDetailModel:self.curModel];
        if (isSuccess)
        {
            [cBtn setSelected:YES];
            LXLog(@"收藏成功");
        }
    }
}

#pragma mark 导航栏返回按钮
-(void)DetailBar:(id)detailBar andBack:(id)back
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Refresh" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 导航栏 透明度显示
-(void)DetailView:(id)detailView andScrollView:(id)scrollView
{
    UIScrollView *myScroll = (UIScrollView *)scrollView;
    self.headerBar.contentView.alpha = myScroll.contentOffset.y / self.view.bounds.size.height*	2;
}


#pragma mark - 划动显示功能实现相关方法
#pragma mark - 显示前一个菜品
-(void)changeToBefore
{
    //移动视图
    self.nextModel = self.curModel;
    self.nextView.model = self.nextModel;
    
    self.curModel = self.beforeModel;
    self.curView.model = self.beforeModel;
    
    //设置显示位置
    self.scrollView.contentOffset = CGPointMake(self.view.bounds.size.width, 0);
    
    //设置收藏按钮的状态
    self.headerBar.contentView.alpha = 0.f;
    [self.headerBar setTitle:self.curModel.Title];
    [self.headerBar.collectionBtn setSelected:[DataBaseHandle isCollectWithDetailModel:self.curModel]];
    
    self.curIndex -= 1;
    [self loadBeforeModel];
}

#pragma mark  显示下一个菜品
-(void)changeToNext
{
    //移动视图
    self.beforeModel = self.curModel;
    self.beforeView.model = self.curModel;
    
    self.curModel = self.nextModel;
    self.curView.model = self.nextModel;
    
    //设置显示位置
    self.scrollView.contentOffset = CGPointMake(self.view.bounds.size.width, 0);
    
    //设置收藏按钮的状态
    self.headerBar.contentView.alpha = 0.f;
    [self.headerBar setTitle:self.curModel.Title];
    [self.headerBar.collectionBtn setSelected:[DataBaseHandle isCollectWithDetailModel:self.curModel]];
    
    //更新当前显示的菜品序号
    self.curIndex += 1;
    
    //加载下一个菜品
    [self loadNextModel];
}

#pragma mark ScrollView拖拽减速结束
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //获取当前显示的第几页
    int page = scrollView.contentOffset.x / self.view.bounds.size.width;
    LXLog(@"%ld", (long)self.curIndex);
    
    if (self.listArray.count == 2) {
        return;
    }
    
    if ((self.curIndex == 0 || self.curIndex == 1) && page == 0) {
        LXLog(@"到了最前面");
        
        if (self.curIndex == 0 && page == 0) {
            return ;
        }
        
        if (self.curIndex == 1)
        {
            [self.headerBar setTitle:self.beforeModel.Title];
            self.curView.scrollView.contentOffset = CGPointZero;
        }
        
        return ;
    }
    if ( (self.curIndex == self.listArray.count - 1 ||self.curIndex == self.listArray.count - 2) && page == 2) {
        LXLog(@"到了最后面");
        if (self.curIndex == self.listArray.count - 2) {
            [self.headerBar setTitle:self.nextModel.Title];
            self.curView.scrollView.contentOffset = CGPointMake(self.view.bounds.size.width, 0);
        }
        return ;
    }
    
    //根据滑动，实现动态加载数据
    switch (page) {
        case 0:
        {
            self.curView.scrollView.contentOffset = CGPointZero;
            [self changeToBefore];
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            self.curView.scrollView.contentOffset = CGPointZero;
            [self changeToNext];
        }
            break;
            
        default:
            break;
    }

    [self.headerBar.collectionBtn setSelected:[DataBaseHandle isCollectWithDetailModel:self.curModel]];
    [self.headerBar setTitle:self.curModel.Title];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (![[AFNetworkReachabilityManager sharedManager] isReachable])
    {
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"" message:@"无网络，无法查看详情" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alterView show];
        return ;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
