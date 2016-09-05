//
//  MNPicturesViewController.m
//  GankMM
//
//  Created by 马宁 on 16/9/5.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import "MNPicturesViewController.h"
#import "GankModel.h"
#import "MNPicturesCell.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "PhotoBroswerVC.h"
#import "MNGankDao.h"
#import "MNUtils.h"
#import "JGWaterflowLayout.h"

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


@interface MNPicturesViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,JGWaterflowLayoutDelegate>

/**
 *  数据
 */
@property(nonatomic,strong)NSMutableArray *gankDatas;

/**
 *  第几页数据
 */
@property(nonatomic,assign)NSInteger pageIndex;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation MNPicturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self setNavigation];
    
    [self initViews];
    
    [self initRefresh];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    
    //创建布局
    JGWaterflowLayout *layout = [[JGWaterflowLayout alloc] init];
    layout.delegate = self;
    
    //创建collectionView
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.942 alpha:1.000];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    //注册
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MNPicturesCell class]) bundle:nil] forCellWithReuseIdentifier:MNGirlsCellID];
    
    
}

/**
 *  刷新
 */
-(void)initRefresh
{
    //下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDatas)];
    //上拉加载
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDatas)];
    //自动改变透明度
    self.collectionView.mj_header.automaticallyChangeAlpha = NO;
    [self.collectionView.mj_footer setHidden:YES];
    
    //获取缓存数据
    NSArray *cacheDatas = [MNGankDao queryCacheWithType:@"福利"];
    if(cacheDatas!=nil && cacheDatas.count>0){
        _pageIndex = 1;
        _gankDatas = (NSMutableArray *)cacheDatas;
        [self.collectionView.mj_footer setHidden:NO];
        [self.collectionView reloadData];
    }else{
        //立马刷新
        [self.collectionView.mj_header beginRefreshing];
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
        [self.collectionView.mj_header endRefreshing];
        return;
    }
    
    //显示网络状态
    [MNUtils showNetWorkActivityIndicator:YES];
    
    _pageIndex = 1;
    flag = 0;
    
    [GankNetApi getGankDataWithType:@"福利" pageSize:pageSize pageIndex:_pageIndex success:^(NSDictionary *dict) {
        
        if(flag == 1){
            return;
        }
        
        _pageIndex ++;
        
        //字典转模型
        self.gankDatas = [GankModel mj_objectArrayWithKeyValuesArray:dict[@"results"]];
        
        
        //刷新表格
        [self.collectionView reloadData];
        
        //结束刷新
        [self.collectionView.mj_header endRefreshing];
        
        if(self.gankDatas.count > 0){
            [self.collectionView.mj_footer setHidden:NO];
        }
        
        //保存最新的20条数据到数据库
        [MNGankDao saveCache:self.gankDatas type:@"福利"];
        
        //网络状态
        [MNUtils showNetWorkActivityIndicator:NO];
        
        
    } failure:^(NSString *text) {
        
        //结束刷新
        [self.collectionView.mj_header endRefreshing];
        
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
        [self.collectionView.mj_footer endRefreshing];
        return;
    }
    
    //网络状态
    [MNUtils showNetWorkActivityIndicator:YES];
    
    flag = 1;
    [GankNetApi getGankDataWithType:@"福利" pageSize:pageSize pageIndex:_pageIndex success:^(NSDictionary *dict) {

        if(flag == 0){
            return;
        }
        //页码+1
        _pageIndex ++;
        
        //字典转模型
        NSMutableArray *newDatas = [GankModel mj_objectArrayWithKeyValuesArray:dict[@"results"]];
        
        
        //判断新的数据和旧的数据有没有一样的
        GankModel *gankModel;
        GankModel *gankModelNew;
        for (int i=0; i<self.gankDatas.count; i++) {
            gankModel = self.gankDatas[i];
            for (int j= 0; j<newDatas.count; j++) {
                gankModelNew = newDatas[j];
                if([gankModelNew._id isEqualToString:gankModel._id]){
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
        [self.collectionView reloadData];
        
        //结束刷新
        [self.collectionView.mj_footer endRefreshing];
        //网络状态
        [MNUtils showNetWorkActivityIndicator:NO];
        
    } failure:^(NSString *text) {
        //结束刷新
        [self.collectionView.mj_footer endRefreshing];
        //网络状态
        [MNUtils showNetWorkActivityIndicator:NO];
    }];
    
}



#pragma mark - <JGWaterflowLayoutDelegate> -
- (CGFloat)waterflowlayout:(JGWaterflowLayout *)waterlayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth {
    //随机数
    CGFloat imageHeight = 200 +  (arc4random() % 201);
    return imageHeight;
    
}

- (CGFloat)rowMarginInWaterflowLayout:(JGWaterflowLayout *)waterflowLayout {
    return 10;
}

- (CGFloat)columnCountInWaterflowLayout:(JGWaterflowLayout *)waterflowLayout {
    return 2;
}

- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(JGWaterflowLayout *)waterflowLayout {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


#pragma mark - <UICollectionViewDataSource> -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.gankDatas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MNPicturesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MNGirlsCellID forIndexPath:indexPath];
    cell.gankModel = self.gankDatas[indexPath.item];
    return cell;
}

#pragma mark -- <--UICollectionViewDelegate-->
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MNLog(@"---%zd---",indexPath.row);
    
    [self networkImageShow:indexPath.row];
}

/*
 *  展示网络图片
 */
-(void)networkImageShow:(NSInteger)index{
    
    //图片集合
    NSMutableArray *networkImages = [NSMutableArray array];
    for (int i =0; i<self.gankDatas.count; i++) {
        GankModel *gankModel = self.gankDatas[i];
        [networkImages addObject:gankModel.url];
    }
    
    //避免循环引用
    __weak typeof(self) weakSelf=self;
    [PhotoBroswerVC show:weakSelf type:PhotoBroswerVCTypeModal index:index photoModelBlock:^NSArray *{
        
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:networkImages.count];
        for (NSUInteger i = 0; i< networkImages.count; i++) {
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            pbModel.image_HD_U = networkImages[i];
            
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
        
        
    }];
    
    [[MNTopWindowController shareInstance] setStatusBarStyle:UIStatusBarStyleLightContent];
}



@end
