//
//  HeaderBar.m
//  healthfood
//
//  Created by lanou on 15/6/23.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#ifdef DEBUG
#define LXLog(...) NSLog(__VA_ARGS__)
#else
#define LXLog(...)
#endif

#import "HeaderBar.h"

@interface HeaderBar () <UITextFieldDelegate>

@property (nonatomic, retain)UIButton *opitionBtn;
@property (nonatomic, retain)UIButton *categoryBtn;
@property (nonatomic, retain)UIButton *searchBtn;
@property (nonatomic, retain)UILabel *titleLabel;
@property (nonatomic, retain)UILabel *lineLabel;
@property (nonatomic, retain)UIButton *deleteBtn;
@property (nonatomic, retain)UITextField *searchText;

@property (nonatomic, retain)NSString *searchString;
@property (nonatomic, assign)BOOL isSearching;
@end

@implementation HeaderBar

-(void)dealloc
{
    LXLog(@"headerBar 已经彻底释放了");
    [_opitionBtn release];
    [_categoryBtn release];
    [_searchBtn release];
    [_titleLabel release];
    [_lineLabel release];
    [_deleteBtn release];
    [_searchText release];
    [_searchString release];
    
    [super dealloc];
}


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        CGFloat subWidth = frame.size.width;
        CGFloat subHeight = frame.size.height - 5;
        
        //添加选项按钮
        self.opitionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.opitionBtn.frame = CGRectMake(10, 0, subHeight, subHeight);
        [self.opitionBtn setBackgroundImage:[UIImage imageNamed:@"opition124"] forState:UIControlStateNormal];
        [self.opitionBtn addTarget:self action:@selector(doOpition:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.opitionBtn];
        
        //添加分类标题按钮
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15 + subHeight, subHeight/4, subWidth/2, subHeight/2)] autorelease];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLabel];
        
        
        
        //添加分类按钮
        self.categoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.categoryBtn.frame = CGRectMake(subWidth - subHeight, 0, subHeight, subHeight);
        [self.categoryBtn setBackgroundImage:[UIImage imageNamed:@"category1"] forState:UIControlStateNormal];
        [self.categoryBtn addTarget:self action:@selector(doCategory:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.categoryBtn];
        
        //添加搜索按钮
        self.searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.searchBtn.frame = CGRectMake(subWidth - subHeight*2, 0, subHeight, subHeight);
        [self.searchBtn setBackgroundImage:[UIImage imageNamed:@"search1"] forState:UIControlStateNormal];
        [self.searchBtn addTarget:self action:@selector(doSearch:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.searchBtn];
        
        self.isSearching = NO;
        
        
        //添加搜索文本框
        self.searchText = [[[UITextField alloc] initWithFrame:CGRectMake(subHeight + 10, (subHeight - 25)/2, subWidth-subHeight*3, 25)] autorelease];
        self.searchText.delegate = self;
        self.searchText.textColor = [UIColor whiteColor];
        self.searchText.font = [UIFont boldSystemFontOfSize:20];
        [self.searchText addTarget:self action:@selector(doSearchTextChange:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:self.searchText];
        self.searchText.hidden = YES;
        self.searchText.returnKeyType = UIReturnKeySearch;
        
        //添加删除按钮
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteBtn addTarget:self action:@selector(doDelete:) forControlEvents:UIControlEventTouchUpInside];
        self.deleteBtn.frame = CGRectMake(subWidth - subHeight*3 + subHeight/4, 0, subHeight, subHeight);
        [self.deleteBtn setImage:[UIImage imageNamed:@"delete1"] forState:UIControlStateNormal];
        self.deleteBtn.hidden = YES;
        self.searchText.delegate = self;
        [self.contentView addSubview:self.deleteBtn];
        
        
        //添加文本框下滑线
        self.lineLabel = [[[UILabel alloc] initWithFrame:CGRectMake(subHeight + 10,subHeight-4, subWidth-subHeight*3 - subHeight/4 , 2)] autorelease];
        self.lineLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.lineLabel];
        self.lineLabel.hidden = YES;
        
    }
    
    return self;
}

-(void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}
#pragma mark item delelte按钮响应方法
-(void)doDelete:(id)sender
{
    self.searchText.text = @"";
    [self textFieldShouldReturn:self.searchText];
    [self doSearchTextChange:self.searchText];
    
}

#pragma mark item Option按钮响应方法
-(void)doOpition:(id)sender
{
    if (self.isSearching == NO)
    {
        [self.delegate headerBar:self andOption:sender];
    }
    else
    {
        self.searchText.text = @"";
        self.searchText.hidden = YES;
        self.lineLabel.hidden = YES;
        self.deleteBtn.hidden = YES;
        self.titleLabel.hidden = NO;
        self.isSearching = NO;
        [self.delegate headerBarEndSearch];
        [self.searchText resignFirstResponder];
        [self.opitionBtn setBackgroundImage:[UIImage imageNamed:@"opition124"] forState:UIControlStateNormal];
    }
    
}

#pragma mark item category按钮响应方法
-(void)doCategory:(id)sender
{
    [self.delegate headerBar:self andCategory:sender];
}


#pragma mark item search按钮响应方法
- (void)doSearch:(id)sender
{
    
    if (self.isSearching == NO)
    {
        self.titleLabel.hidden = YES;
        self.lineLabel.hidden = NO;
        self.searchText.hidden = NO;
        self.deleteBtn.hidden = NO;
        [self.opitionBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        
        [self.delegate headerBarBeginSearch];
        [self.searchText becomeFirstResponder];
        
        self.isSearching = YES;
    }
    else
    {
        [self textFieldShouldReturn:self.searchText];
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if ([self.searchString isEqualToString:textField.text]) {
        return YES;
    }
    else
    {
        self.searchString = textField.text;
    }
    
    [self.delegate headerBar:self andSearchText:textField.text];
    
    return YES;
}

#pragma mark 响应文本变化
-(void)doSearchTextChange:(UITextField *)textField
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
