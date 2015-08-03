//
//  DeveloperViewController.m
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

#import "DeveloperViewController.h"
#import "Bar.h"
#import "CollectionBar.h"

@interface DeveloperViewController ()<UIScrollViewDelegate>

@property (nonatomic,retain)Bar *headerBar;
@property (nonatomic, retain)UIScrollView *scrollView;
@property (nonatomic,retain)CollectionBar *collectionBar;

@end

@implementation DeveloperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //滚动视图
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height-20)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.backgroundColor=[UIColor whiteColor];
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;

    [self.view addSubview:self.scrollView];
    
    
    //关于我们的开发者门视图
    UIImage *image = [UIImage imageNamed:@"developer.png"];
    CGFloat rate = self.view.bounds.size.width/image.size.width;
    UIImageView *developerImageView=[[[UIImageView alloc] initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, image.size.height * rate)] autorelease];
    developerImageView.image = image;
    [self.scrollView addSubview:developerImageView];
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, developerImageView.bounds.size.height - 20);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    
    
    //导航外观条
    self.headerBar=[[[Bar alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 60)] autorelease];
    [self.view addSubview:self.headerBar];
    
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame= CGRectMake(10, 0, self.headerBar.bounds.size.height, self.headerBar.bounds.size.height);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back2"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(doOpition:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerBar addSubview:backBtn];
    
    self.headerBar.contentView.alpha = 0.2f;
    
    UISwipeGestureRecognizer *swipeGest = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doOpition:)];
    swipeGest.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGest];
    

}

-(void)doOpition:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
