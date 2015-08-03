//
//  ViewController.m
//  healthfood
//
//  Created by lanou on 15/6/22.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#ifdef DEBUG
#define LXLog(...) NSLog(__VA_ARGS__)
#else
#define LXLog(...)
#endif

#import "AppDelegate.h"
#import "ViewController.h"

#import "HeaderBar.h"
#import "CategoryModel.h"
#import "CategoryListModel.h"
#import "CategortyViewController.h"

#import "OpitionViewController.h"
#import "DetailAllViewController.h"

#import "Reachability.h"
#import "LXFoodNetWork.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"


#import "MJRefresh.h"
#import "MJChiBaoZiHeader.h"
#import "MJChiBaoZiFooter.h"
#import "UIImageView+WebCache.h"

#import "MyCollectionViewCell.h"
#import "LXWaterfallFlowlayout.h"

@interface ViewController ()<LXWaterfallFlowlayoutDelegate, UICollectionViewDataSource , HeaderBarDelegate>

@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) BOOL isSearching;
@property (nonatomic, retain) HeaderBar *headerBar;
@property (nonatomic, retain) NSMutableArray *resultArray;
@property (nonatomic, retain) OpitionViewController *opitionSider;

@property (nonatomic, retain) UICollectionView *collectionView;

@end

@implementation ViewController


-(UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        LXWaterfallFlowlayout *layout = [[LXWaterfallFlowlayout alloc] init];
        layout.columnCount = 2;
        layout.delegate = self;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        CGRect frame = self.view.bounds;
        frame.origin.y = 58;
        frame.size.height -= 58;
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
    }
    
    return _collectionView;
}


-(void)dealloc
{
    [_resultArray release];
    [_modelArray release];
    [_category release];
    [_opitionSider release];
    [_headerBar release];
    
    
    [super dealloc];
}


#pragma mark - 数据处理
#pragma mark - 解析model数据
-(void)decodeModelData:(NSData *)data
{
    if (data == nil)
    {
        return ;
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    if (dict == nil) {
        return ;
    }
    
    dict = dict[@"result"];
    NSArray *list = dict[@"list"];
    
    for (NSDictionary *modelDict in list)
    {
        CategoryListModel *model = [[CategoryListModel alloc] init];
        model.Title = modelDict[@"Title"];
        model.Cover = modelDict[@"Cover"];
        model.Stuff = modelDict[@"Stuff"];
        model.RecipeId = modelDict[@"RecipeId"];
        
        if (self.isSearching)
        {
            [self.resultArray addObject:model];
        }
        else
        {
            [self.modelArray addObject:model];
        }
        
        [model release];
    }
}

#pragma mark 加载model数据
-(void)loadModelDataWithLimit:(NSInteger)limit
{
    
    Reachability *netWortStatu = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (![netWortStatu isReachable]) {
        LXLog(@"网络不给力");
        [self.collectionView.footer endRefreshing];
        return ;
    }
    
    //网络请求数据
    __block ViewController *weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [LXFoodNetWork arrayWithCategoryIds:self.category.idArray andLimit:limit andOffset:self.offset andResultBlock:^(NSArray *dataArray) {
        //解析数据
        for (NSData *data in dataArray)
        {
            [weakSelf decodeModelData:data];
        }
        LXLog(@"网络请求完毕");
        weakSelf.offset = weakSelf.modelArray.count;
        [weakSelf.collectionView reloadData];
        [weakSelf.collectionView.footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}
-(void)loadNextPageData
{

    [self loadModelDataWithLimit:5];
}


#pragma mark 初始化model数组
-(void) initModelData
{
    self.offset = 0;
    [self.modelArray removeAllObjects];
    [self.collectionView reloadData];
    
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [[manager imageCache] setMaxMemoryCost:10];
    
    [[manager imageCache] clearDisk];
    [[manager imageCache] clearMemory];
    [[manager imageCache] setMaxMemoryCost:1000000];
    
    [self loadModelDataWithLimit:5];
}

#pragma mark - headerBar代理方法
#pragma mark item Option按钮响应方法
-(void)headerBar:(id)headerBar andOption:(UIButton *)opition
{
    [self.opitionSider showHideSidebar];
}

#pragma mark item category按钮响应方法
-(void)headerBar:(id)headerBar andCategory:(UIButton *)category
{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    CategortyViewController *rootVC = [[[CategortyViewController alloc] init] autorelease];
    [rootVC setTitle:self.category.title];
    [self.navigationController pushViewController:rootVC animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CategoryNotifi:) name:@"category" object:nil];
}

#pragma mark category通知响应方法
- (void)CategoryNotifi:(NSNotification *)notification
{
    LXLog(@"接到类目更改通知");
    self.category = (CategoryModel *)notification.userInfo[@"key"];
    [self.headerBar setTitle:self.category.title];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"category" object:nil];
    
    [self initModelData];
}

#pragma mark item search按钮响应方法
-(void)headerBar:(id)headerBar andSearchText:(NSString *)searchText
{
    
    __block ViewController *weakSealf = self;
    [MBProgressHUD showHUDAddedTo:self.collectionView animated:YES];
    [LXFoodNetWork dataWithSearchTextL:searchText andResultBlock:^(NSData *resultData) {
       
        [self.resultArray removeAllObjects];
        [weakSealf decodeModelData:resultData];
        [weakSealf.collectionView reloadData];
        [MBProgressHUD hideHUDForView:self.collectionView animated:YES];
        
    }];
}

-(NSMutableArray *)resultArray
{
    if (_resultArray == nil) {
        _resultArray = [[NSMutableArray alloc] initWithCapacity:2];
    }
    
    return _resultArray;
}

#pragma mark 开始搜索
-(void)headerBarBeginSearch
{
    self.isSearching = YES;
    [self.collectionView reloadData];
    [self.collectionView.footer removeFromSuperview];
}

-(void)headerBarEndSearch
{
    self.isSearching = NO;
    self.collectionView.footer = [MJChiBaoZiFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextPageData)];
    [self.resultArray removeAllObjects];
    [self.collectionView reloadData];
    
}



#pragma mark - 添加侧滑手势
#pragma mark - 添加侧滑手势
-(void)addSideBar
{
    self.opitionSider = [[[OpitionViewController alloc] init] autorelease];
    [self.view addSubview:self.opitionSider.view];
    self.opitionSider.view.frame = self.view.bounds;
    
    UIPanGestureRecognizer *panGusture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [panGusture delaysTouchesBegan];
    [self.view addGestureRecognizer:panGusture];
}

#pragma mark 侧滑响应方法
- (void)panDetected:(UIPanGestureRecognizer*)recoginzer
{
    [self.opitionSider panDetected:recoginzer];
}


#pragma mark - 系统默认方法
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height-20);

    
    //创建barItem
    //*********************************************
    self.isSearching = NO;
    self.headerBar = [[[HeaderBar alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 55)] autorelease];
    self.headerBar.delegate = self;
    self.headerBar.backgroundColor = [UIColor orangeColor];
    [self.headerBar setTitle:self.category.title];
    [self.view addSubview: self.headerBar];
    
    //创建侧滑视图
    [self addSideBar];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: self.collectionView];
    
    UINib *myNib = [UINib nibWithNibName:@"MyCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:myNib forCellWithReuseIdentifier:@"Cell"];
    
    
    self.collectionView.footer = [MJChiBaoZiFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextPageData)];
    [self.view sendSubviewToBack:self.collectionView];
    [self.collectionView reloadData];
    
    if (self.modelArray == nil || self.modelArray.count == 0)
    {
        LXLog(@"初始数据库没有数据");
        //加载数据
        //*********************************************
        self.offset = 0;
        self.category = [[[CategoryModel alloc] initWithTitle:@"美容瘦身" andImageName:@"美容瘦身1.jpg" andIdArray:@[@"320", @"323", @"2792", @"321"]] autorelease];
        self.modelArray = [[[NSMutableArray alloc] initWithCapacity:2] autorelease];
        [self.collectionView.footer beginRefreshing];
    }
    else
    {
        LXLog(@"数据库有数据拉");
        self.offset = self.modelArray.count;
    }
    
    [self.headerBar setTitle:self.category.title];
}

#pragma mark 内存警告方法
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    LXLog(@"-------内存发警告了哦---------");
}


#pragma mark - 测试
#pragma mark -
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.isSearching) {
        return self.resultArray.count;
    }
    return self.modelArray.count;
}

-(NSUInteger)numberOfItemsInCollectionView
{
    if (self.isSearching) {
        return self.resultArray.count;
    }
    return self.modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    CategoryListModel *model;
    if (self.isSearching) {
        model = self.resultArray[indexPath.row];
    }
    else
    {
        model =  self.modelArray[indexPath.row];
    }
    
    cell.title = model.Title;
    cell.imageUrl = model.Cover;
    
    
    return cell;
}

#pragma -mark返回每个item的高度的方法<UICollectionViewDelegateWaterFlowLayout>协议方法
- (CGFloat)collectionView:(UICollectionView *)collectionView waterFlowLayout:(LXWaterfallFlowlayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CategoryListModel *m;
    if (self.isSearching) {
        m = self.resultArray[indexPath.row];
    }
    else
    {
        m = self.modelArray[indexPath.row];
    }

    
    if (m.coverImage == nil) {
        return 100;
    }

    CGFloat height = m.coverImage.size.height;
    if (height <= 50) {
        return height;
    }
    else if (height < 100) {
        return height = height / 2;
    }
    
    
    return   height / 1.7 / 2;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (![[AFNetworkReachabilityManager sharedManager] isReachable])
    {
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"" message:@"无网络，无法查看详情" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alterView show];
        return ;
    }
    
    DetailAllViewController *detailAllVC = [[DetailAllViewController alloc] init];
    if (self.isSearching)
    {
        detailAllVC.listArray = self.resultArray;
    }
    else
    {
        
        detailAllVC.listArray = self.modelArray;
    }
    
    detailAllVC.curIndex = indexPath.row;
    
    [self.navigationController pushViewController:detailAllVC animated:YES];
    
    [detailAllVC release];
}




@end
