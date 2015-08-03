//
//  OpitionViewController.m
//  Waterflow
//
//  Created by lanou on 15/6/21.
//  Copyright (c) 2015年 yangjw . All rights reserved.
//

#ifdef DEBUG
#define LXLog(...) NSLog(__VA_ARGS__)
#else
#define LXLog(...)
#endif

#import "OpitionViewController.h"
#import "OpitionTableViewCell.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "CollectionViewController.h"
#import "DeveloperViewController.h"
#import "UIImageView+WebCache.h"



@interface OpitionViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic ,retain) UITableView *tableView;
@property (nonatomic ,retain) NSMutableArray *modelArray;
@property (nonatomic, assign) NSInteger selectIndex;

@end


@implementation OpitionViewController


-(void)dealloc
{
    LXLog(@"OpitionViewController 已经释放了");
    [_tableView release];
    [_modelArray release];
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.modelArray = [[[NSMutableArray alloc] initWithObjects:@{@"食谱":@"食谱"},@{@"收藏":@"收藏"},@{@"清除缓存":@"小贴士"},@{@"关于我们":@"关于我们"}, nil] autorelease];
    
    UIView *backView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    [backView release];
    
    CGRect frame = self.contentView.bounds;
    UIImage *image = [UIImage imageNamed:@"美容瘦身.jpg"];
    CGFloat rate = self.contentView.frame.size.width / image.size.width;
    UIImageView *headerImage = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 20, self.contentView.frame.size.width, image.size.height * rate)] autorelease];
    headerImage.image = image;
    [self.contentView addSubview:headerImage];
    
    frame.origin.y = image.size.height*rate + 20;
    frame.size.height = image.size.height*rate + 100;
    
    self.tableView = [[[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain] autorelease];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview: self.tableView];
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strID = @"cellID";
    OpitionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if (cell == nil) {
        cell = [[[OpitionTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strID] autorelease];
    }
    

    NSDictionary *model = self.modelArray[indexPath.row];
    cell.photoImage.image = [UIImage imageNamed:[model allValues][0]];
    cell.titleLabel.text = [model allKeys][0];
    
    if (indexPath.row == 2) {
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        NSUInteger size = [[manager imageCache] getSize];
        
        [cell setAccessoryText:[NSString stringWithFormat:@"%.2fM", size/1000.0/1000.0]];
       
        
    }

    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *header = [[[UILabel alloc] init] autorelease];
    header.backgroundColor = [UIColor whiteColor];
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.selectIndex = indexPath.row;    

    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    
    switch (indexPath.row) {
        case 0:
        {
            LXLog(@"显示食谱");
        }
            break;
        case 1:
        {
            CollectionViewController *collectVc = [[CollectionViewController alloc]init];
            [app.viewVC.navigationController pushViewController:collectVc animated:YES];
            [collectVc release];
        }
            break;
        case 2:
        {
            LXLog(@"显示小贴士");
            
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [[manager imageCache]  clearMemory];
            [[manager imageCache] clearDisk];
            [[manager imageCache] cleanDisk];
            
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:@"缓存已经清空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alter show];
            
            OpitionTableViewCell *cell = (OpitionTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            
            NSUInteger size = [[manager imageCache] getSize];
            [cell setAccessoryText:[NSString stringWithFormat:@"%.1f", size/1000.0/1000.0]];
            
        }
            break;
        case 3:
        {
            DeveloperViewController *developVC = [[DeveloperViewController alloc] init];
            [app.viewVC.navigationController pushViewController:developVC animated:YES];
            [developVC release];
        }
            
        default:
            break;
    }
    //取消被选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self showHideSidebar];
}

- (void)slideToRightOccured
{
    LXLog(@"滑动了");
}

- (void)sidebarDidShown
{
    LXLog(@"滑动往了");
}

- (void)slideToRightBegin
{
    LXLog(@"开始滑动");
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    
    OpitionTableViewCell *cell = (OpitionTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    

    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSUInteger size = [[manager imageCache] getSize];
    NSString *sizeString = [NSString stringWithFormat:@"%.1f", size/1000.0/1000.0];
    [cell setAccessoryText:sizeString];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

    
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
