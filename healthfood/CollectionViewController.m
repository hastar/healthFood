//
//  CollectionViewController.m
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

#import "CollectionViewController.h"
#import "AppDelegate.h"
#import "CollectionBar.h"
#import "DetailModel.h"
#import "DetailViewController.h"
#import "DetailAllViewController.h"

#import "MJRefresh.h"
#import "MJChiBaoZiHeader.h"
#import "MJChiBaoZiFooter.h"

#import "DataBaseHandle.h"
#import "LXWaterfallFlowlayout.h"
#import "MyCollectionViewCell.h"

@interface CollectionViewController () <LXWaterfallFlowlayoutDelegate, UICollectionViewDataSource, CollectionBarDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) UICollectionView *collectView;
@property (nonatomic, retain) CollectionBar *headerBar;
@property (nonatomic, retain) NSMutableArray *modelArray;

@end

@implementation CollectionViewController

-(void)dealloc
{
    LXLog(@"收藏页面释放完毕");
    [_modelArray release];
    [_headerBar release];
    [_collectView release];
    
    [super dealloc];
}



- (void)loadModelData
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Refresh" object:nil];
    
    [self.modelArray removeAllObjects];
    [self.modelArray addObjectsFromArray:[DataBaseHandle arrayWithCollectModels]];
    
     LXLog(@"mArray=========%@",self.modelArray);
    
    [self.collectView reloadData];

}

-(UICollectionView *)collectView
{
    if (_collectView == nil) {
        LXWaterfallFlowlayout *layout = [[LXWaterfallFlowlayout alloc] init];
        layout.columnCount = 2;
        layout.delegate = self;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        CGRect frame = self.view.bounds;
        frame.origin.y = 58;
        frame.size.height -= 58;
        _collectView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        _collectView.dataSource = self;
        _collectView.delegate = self;
        
    }
    
    return _collectView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.modelArray = [[[NSMutableArray alloc] initWithCapacity:2] autorelease];
    
    
    self.headerBar = [[[CollectionBar alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 55)] autorelease];
    self.headerBar.delegate = self;
    [self.view addSubview:self.headerBar];
    
    
    //创建瀑布流
    //*********************************************
    self.collectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: self.collectView];
    
    UINib *myNib = [UINib nibWithNibName:@"MyCollectionViewCell" bundle:nil];
    [self.collectView registerNib:myNib forCellWithReuseIdentifier:@"Cell"];
    
    //把瀑布流qtmquitView放到最底下
    [self.view sendSubviewToBack:self.collectView];
    
    [self loadModelData];
    [self.collectView reloadData];

    
    //添加右划返回手势
    UISwipeGestureRecognizer *leftSwpe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doBack:)];
    leftSwpe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:leftSwpe];
}

-(void)doBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)CollectionBar:(id)collectionBar andBack:(UIButton *)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [DataBaseHandle deleteAllDetailModel];
        [self.modelArray removeAllObjects];
        [self.collectView reloadData];
    }
}

-(void)CollectionBar:(id)collectionBar andOpition:(UIButton *)opition
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:@"将会删除所有收藏菜品" delegate:self cancelButtonTitle:@"删除" otherButtonTitles:@"不了", nil];
    [alter show];
    
    
}

#pragma mark - 测试
#pragma mark -
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.modelArray.count;
}

-(NSUInteger)numberOfItemsInCollectionView
{
    
    return self.modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    DetailModel *model =  self.modelArray[indexPath.row];
    
    
    cell.title = model.Title;
    cell.imageUrl = model.Cover;
    
    
    return cell;
}

#pragma -mark返回每个item的高度的方法<UICollectionViewDelegateWaterFlowLayout>协议方法
- (CGFloat)collectionView:(UICollectionView *)collectionView waterFlowLayout:(LXWaterfallFlowlayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailModel *m = self.modelArray[indexPath.row];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadModelData) name:@"Refresh" object:nil];
    
    if(self.modelArray.count <= 3)
    {
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        detailVC.listModel = self.modelArray[indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
        [detailVC release];
    }
    else
    {
        DetailAllViewController *detailAllVC = [[DetailAllViewController alloc] init];
        detailAllVC.listArray = self.modelArray;
        
        detailAllVC.curIndex = indexPath.row;
        [self.navigationController pushViewController:detailAllVC animated:YES];
        
        [detailAllVC release];
    }
     
   
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
