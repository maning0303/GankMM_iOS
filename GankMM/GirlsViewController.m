//
//  GirlsViewController.m
//  GankMM
//
//  Created by 马宁 on 16/5/9.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import "GirlsViewController.h"
#import "MNGirlsCell.h"
#import "GankModel.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "PhotoBroswerVC.h"
#import "MNGankDao.h"
#import "MNUtils.h"

/**
 *  每页加载的大小
 */
static const NSInteger pageSize = 20;
/**
 *  标记,防止网络不好既上啦又下拉，照成数据混乱，以最后一次为主
 */
static NSInteger flag = 0;
/**
 *  cell标识
 */
static NSString * MNGirlsCellID = @"girls";

@interface GirlsViewController () <UITableViewDelegate,UITableViewDataSource>

/**
 *  数据
 */
@property(nonatomic,strong)NSMutableArray *gankDatas;

/**
 *  第几页数据
 */
@property(nonatomic,assign)NSInteger pageIndex;

/**
 *  TableView
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GirlsViewController

///**
// *  懒加载
// */
//-(NSMutableArray *)gankDatas
//{
//    if(!_gankDatas){
//        _gankDatas = [NSMutableArray array];
//    }
//    return _gankDatas;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigation];
    
    [self initViews];
    
    [self initRefresh];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"--GirlsViewController----viewDidAppear");

}

-(void)viewWillAppear:(BOOL)animated
{
    //状态栏设置
    [[MNTopWindowController shareInstance] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)setNavigation
{
    self.navigationItem.title = @"福利";
}

-(void)initViews
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //距离顶部的调整
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //不要分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MNGirlsCell class]) bundle:nil] forCellReuseIdentifier:MNGirlsCellID];
    
}

/**
 *  刷新
 */
-(void)initRefresh
{
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDatas)];
    //上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDatas)];
    //自动改变透明度
    self.tableView.mj_header.automaticallyChangeAlpha = NO;
    [self.tableView.mj_footer setHidden:YES];
    
    //获取缓存数据
    NSArray *cacheDatas = [MNGankDao queryCacheWithType:@"福利"];
    if(cacheDatas!=nil && cacheDatas.count>0){
        _pageIndex = 1;
        _gankDatas = (NSMutableArray *)cacheDatas;
        [self.tableView.mj_footer setHidden:NO];
        [self.tableView reloadData];
    }else{
        //立马刷新
        [self.tableView.mj_header beginRefreshing];
    }
}

/**
 *  获取数据
 *
 *  @param pageSize  每页大小
 *  @param pageIndex 第几页
 */
-(void)loadNewDatas
{
    //判断有没有网络
    if(![MNUtils isExistenceNetwork]){
        [MyProgressHUD showToast:@"检查你的网络设置"];
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        return;
    }
    
    //显示网络状态
    [MNUtils showNetWorkActivityIndicator:YES];
    
    _pageIndex = 1;
    flag = 0;
    
    [GankNetApi getGankDataWithType:@"福利" pageSize:pageSize pageIndex:_pageIndex success:^(NSDictionary *dict) {
        MNLog(@"---loadNewDatas-success---%@",dict);
        if(flag == 1){
            return;
        }
    
        _pageIndex ++;
        
        //字典转模型
        self.gankDatas = [GankModel mj_objectArrayWithKeyValuesArray:dict[@"results"]];
        MNLog(@"---loadNewDatas-gankDatas---%zd",self.gankDatas.count);
        
        //刷新表格
        [self.tableView reloadData];
        
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        
        if(self.gankDatas.count > 0){
            [self.tableView.mj_footer setHidden:NO];
        }
        
        //保存最新的20条数据到数据库
        [MNGankDao saveCache:self.gankDatas type:@"福利"];
        
        //网络状态
        [MNUtils showNetWorkActivityIndicator:NO];

        
    } failure:^(NSString *text) {
        MNLog(@"----loadNewDatas-失败----%@",text);
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        
        //显示网络状态
        [MNUtils showNetWorkActivityIndicator:NO];
        
    }];
}

-(void)loadMoreDatas
{
    //判断有没有网络
    if(![MNUtils isExistenceNetwork]){
        [MyProgressHUD showToast:@"检查你的网络设置"];
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    
    //网络状态
    [MNUtils showNetWorkActivityIndicator:YES];
    
    flag = 1;
    [GankNetApi getGankDataWithType:@"福利" pageSize:pageSize pageIndex:_pageIndex success:^(NSDictionary *dict) {
        MNLog(@"---loadMoreDatas-success---%@",dict);
        if(flag == 0){
            return;
        }
        //页码+1
        _pageIndex ++;
        
        //字典转模型
        NSMutableArray *newDatas = [GankModel mj_objectArrayWithKeyValuesArray:dict[@"results"]];
        
        MNLog(@"---loadMoreDatas-newDatas---%@",newDatas);
        
        
        //判断新的数据和旧的数据有没有一样的
        GankModel *gankModel;
        GankModel *gankModelNew;
        for (int i=0; i<self.gankDatas.count; i++) {
            gankModel = self.gankDatas[i];
            for (int j= 0; j<newDatas.count; j++) {
                gankModelNew = newDatas[j];
                if([gankModelNew._id isEqualToString:gankModel._id]){
                    NSLog(@"移除：%@",gankModelNew.desc);
                    //移除出集合
                    [newDatas removeObjectAtIndex:j];
                }
            }
        }
        
        if(newDatas!=nil && newDatas.count>0){
            //把请求的数组放到当前类别的数组集合中去
            [self.gankDatas addObjectsFromArray:newDatas];
        }
        
        //刷新表格
        [self.tableView reloadData];
        
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
        //网络状态
        [MNUtils showNetWorkActivityIndicator:NO];
        
    } failure:^(NSString *text) {
        MNLog(@"----loadNewDatas-失败----%@",text);
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
        //网络状态
        [MNUtils showNetWorkActivityIndicator:NO];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.gankDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取Cell
    MNGirlsCell *cell = [tableView dequeueReusableCellWithIdentifier:MNGirlsCellID];
    
    //cell赋值
    cell.gankModel = self.gankDatas[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MNLog(@"---%zd---",indexPath.row);
    
    [self networkImageShow:indexPath.row];
}

/*
 *  展示网络图片
 */
-(void)networkImageShow:(NSInteger)index{
    //获取当前cell
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    MNGirlsCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    //图片集合
    NSMutableArray *networkImages = [NSMutableArray array];
    for (int i =0; i<self.gankDatas.count; i++) {
        GankModel *gankModel = self.gankDatas[i];
        [networkImages addObject:gankModel.url];
    }
    
    [PhotoBroswerVC show:self type:PhotoBroswerVCTypeModal index:index photoModelBlock:^NSArray *{
        
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:networkImages.count];
        for (NSUInteger i = 0; i< networkImages.count; i++) {
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
//            pbModel.title = [NSString stringWithFormat:@"这是标题%@",@(i+1)];
//            pbModel.desc = [NSString stringWithFormat:@"描述文字%@",@(i+1)];
            pbModel.image_HD_U = networkImages[i];
            //源frame
            UIImageView *imageV = cell.imageViewShow;
            pbModel.sourceImageView = imageV;
            
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
        
        
    }];
    
    [[MNTopWindowController shareInstance] setStatusBarStyle:UIStatusBarStyleLightContent];
}

@end
