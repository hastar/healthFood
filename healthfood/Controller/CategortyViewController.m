//
//  CategortyViewController.m
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


#import "CategortyViewController.h"
#import "CategoryCollectionViewCell.h"
#import "CategoryModel.h"


#define kSubWidth ([UIScreen mainScreen].bounds.size.width/13)
@interface CategortyViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, retain)UICollectionView *collection;
@property (nonatomic, retain)NSMutableArray *modelArray;

@end

@implementation CategortyViewController

-(void)dealloc
{
    LXLog(@"CategortyViewController 已经释放了");
    [_collection release];
    [_modelArray release];
    [_viewVC release];
    
    [super dealloc];
}


-(void)initModelData
{
    CategoryModel *m1 = [[CategoryModel alloc] initWithTitle:@"美容瘦身" andImageName:@"美容瘦身1.jpg" andIdArray:@[@"320", @"323", @"2792", @"321"]];
    [self.modelArray addObject:m1];
    [m1 release];
    
    CategoryModel *m2 = [[CategoryModel alloc] initWithTitle:@"健脾开胃" andImageName:@"健脾开胃1.jpg" andIdArray:@[@"49249", @"348"]];
    [self.modelArray addObject:m2];
    [m2 release];
    
    CategoryModel *m3 = [[CategoryModel alloc] initWithTitle:@"清热解毒" andImageName:@"清热解毒.jpg" andIdArray:@[@"7553", @"350"]];
    [self.modelArray addObject:m3];
    [m3 release];
    
    CategoryModel *m4 = [[CategoryModel alloc] initWithTitle:@"滋阴补阳" andImageName:@"滋阴补阳.jpg" andIdArray:@[@"347", @"2200", @"58319"]];
    [self.modelArray addObject:m4];
    [m4 release];
    
    CategoryModel *m5 = [[CategoryModel alloc] initWithTitle:@"头疼解酒" andImageName:@"头疼解酒1.jpg" andIdArray:@[@"97540", @"812"]];
    [self.modelArray addObject:m5];
    [m5 release];
    
    
    CategoryModel *m6 = [[CategoryModel alloc] initWithTitle:@"消化不良" andImageName:@"消化不良2.jpg" andIdArray:@[@"28658", @"810"]];
    [self.modelArray addObject:m6];
    [m6 release];
    
    CategoryModel *m7 = [[CategoryModel alloc] initWithTitle:@"清肝明目" andImageName:@"美容瘦身2.jpg" andIdArray:@[@"344", @"325"]];
    [self.modelArray addObject:m7];
    [m7 release];
    
    CategoryModel *m8 = [[CategoryModel alloc] initWithTitle:@"益智补脑" andImageName:@"健脾开胃2.jpg" andIdArray:@[@"52261"]];
    [self.modelArray addObject:m8];
    [m8 release];
    
    CategoryModel *m9 = [[CategoryModel alloc] initWithTitle:@"骨质疏松" andImageName:@"头疼解酒3.jpg" andIdArray:@[@"418", @"7254"]];
    [self.modelArray addObject:m9];
    [m9 release];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(doBack:)];
    
    
    self.modelArray = [[[NSMutableArray alloc] initWithCapacity:2] autorelease];
    [self initModelData];
    
    UICollectionViewFlowLayout *flowLayout = [[[UICollectionViewFlowLayout alloc] init] autorelease];
    flowLayout.minimumLineSpacing = 30;
    flowLayout.minimumInteritemSpacing = kSubWidth - 2;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(kSubWidth, kSubWidth, kSubWidth, kSubWidth);
    
    CGRect frame = self.view.bounds;
    self.collection = [[[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout] autorelease];
    self.collection.backgroundColor = [UIColor whiteColor];
    self.collection.delegate = self;
    self.collection.dataSource = self;
    [self.view addSubview:self.collection];
    
    [self.collection registerClass:[CategoryCollectionViewCell class] forCellWithReuseIdentifier:@"item"];
    
    
    
    //添加右划返回手势
    UISwipeGestureRecognizer *leftSwpe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doBack:)];
    leftSwpe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:leftSwpe];
    
}

-(void)doBack:(id)sender
{
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UICollectionView代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modelArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    CategoryModel *m = self.modelArray[indexPath.row];
    cell.imageView1.image = m.image;
    cell.label.text = m.title;
    
    return cell;
}

#pragma -mark设置每个item大小的方法
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kSubWidth * 3, kSubWidth * 3 + 30);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryModel *m = self.modelArray[indexPath.row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"category" object:self userInfo:@{@"key":m}];
    
    
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
