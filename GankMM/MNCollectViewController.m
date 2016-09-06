//
//  MNCollectViewController.m
//  GankMM
//
//  Created by 马宁 on 16/5/12.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import "MNCollectViewController.h"
#import "MNGankDao.h"
#import "MNGankCollectCell.h"
#import "MNWebViewController.h"
#import "GankModel.h"

@interface MNCollectViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *collects;

@end

@implementation MNCollectViewController

/**
 *  cell标识
 */
static NSString * MNCollectCellID = @"MNCollectCellID";

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavigation];
    
    [self initTableView];
    
    [self initData];
    
}

-(void)setNavigation
{
    self.navigationItem.title = @"我的收藏";
    //状态栏设置
    [[MNTopWindowController shareInstance] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MNCollectViewController"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MNCollectViewController"];
}

-(void)viewDidAppear:(BOOL)animated
{
    //更新数据
    [self updateCollectState];
    
}

-(void)initData
{
    _collects = (NSMutableArray *)[MNGankDao queryAll];
    if(_collects!=nil && _collects.count>0){
        //更新数据
//        [self updateCollectState];
    }else{
        [MyProgressHUD showToast:@"收藏为空，快去添加收藏吧!"];
    }
    
}

-(void)initTableView
{
    //距离顶部的调整
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.970 alpha:1.000];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MNGankCollectCell class]) bundle:nil] forCellReuseIdentifier:MNCollectCellID];
    
    //设置高度自适应：IOS 8.0 >
    self.tableView.estimatedRowHeight = 50;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //去掉多余的cell
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)updateCollectState
{
    for (int i=0; i<self.collects.count; i++) {
        GankModel *gankModel = self.collects[i];
        //判断是不是收藏过了
        if([MNGankDao queryIsExist:gankModel._id]){
            gankModel.collect = YES;
        }else{
            gankModel.collect = NO;
            //从集合中移除
            [self.collects removeObjectAtIndex:i];
        }
    }
    //刷新表格
    [self.tableView reloadData];
}

#pragma mark -------TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.collects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取Cell
    MNGankCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:MNCollectCellID];
    //传递数据
    cell.gankModel = self.collects[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //跳转WebView
    MNWebViewController *webViewVc = [[MNWebViewController alloc] init];
    GankModel *gankModel = self.collects[indexPath.row];
    webViewVc.gankModel = gankModel;
    [self.navigationController pushViewController:webViewVc animated:YES];
    
    //还原TableView选中状态
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
}


@end
