//
//  OthersViewController.m
//  GankMM
//
//  Created by 马宁 on 16/5/9.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import "OthersViewController.h"
#import "MNAboutViewController.h"
#import "MNWebViewController.h"
#import "MNCollectViewController.h"
#import "MNGankDao.h"
#import "GankModel.h"
#import "UIScrollView+PullBig.h"

const CGFloat TopViewH = 300;

@interface OthersViewController () <UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,weak)UIImageView *topView;

@end

@implementation OthersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigation];
    
    [self setTopView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    //距离顶部的调整
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}


-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"---OthersViewController---viewDidAppear---%@",animated?@"true":@"false");
    //状态栏设置
    [[MNTopWindowController shareInstance] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [MobClick beginLogPageView:@"OthersViewController"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"OthersViewController"];
}

-(void)setNavigation
{
    self.navigationItem.title = @"";
}

-(void)setTopView
{
    
    //方案二：
    UIImageView *topView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"GankTop"]];
    topView.frame = CGRectMake(0, 0, MNScreenW, MNScreenH * 0.35);
    topView.contentMode = UIViewContentModeScaleAspectFill;
    [self.tableView setBigView:topView withHeaderView:nil];
    
    self.topView = topView;
    
    //点击事件
    self.topView.userInteractionEnabled=YES;
    [self.topView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showAlertSheet)]];
    
    //去掉组形式的第一栏留空隙
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, CGFLOAT_MIN)];
    
    //获取最新的图片替换
    UIImage *localImage = [FileUtils getImageFromLocalImageName:@"topImage.png"];
    if(localImage!=nil){
        self.topView.image = localImage;
    }
}

-(void)showAlertSheet
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"背景图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *copyAction = [UIAlertAction actionWithTitle:@"相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self choosePic];
    }];
    UIAlertAction *otherOpenAction = [UIAlertAction actionWithTitle:@"还原默认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImage *localImage = [UIImage imageNamed:@"GankTop"];
        self.topView.image = localImage;
        //保存图片
        [FileUtils saveImageToLocal:localImage imageName:@"topImage.png"];
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:copyAction];
    [alertController addAction:otherOpenAction];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

-(void)choosePic
{
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [[MNTopWindowController shareInstance] setStatusBarStyle:UIStatusBarStyleDefault];
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    //UIImagePickerControllerEditedImage:裁剪的
    //UIImagePickerControllerOriginalImage:原图
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.topView.image = image;
    //保存图片
    [FileUtils saveImageToLocal:image imageName:@"topImage.png"];
}

#pragma mark ----

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 3;
    }else if(section == 1){
        return 2;
    }else{
        return 0;
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"我的收藏";
                break;
            case 1:
                cell.textLabel.text = @"点个赞";
                break;
            case 2:
                cell.textLabel.text = @"推荐";
                break;

        }
    }else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"清除缓存";
                
                cell.detailTextLabel.text = [self getCacheSizeStr];
                
                break;
            case 1:
                cell.textLabel.text = @"关于";
                break;
        }
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];

    
    return cell;
}

-(NSString *)getCacheSizeStr
{
    float cacheSize = [[SDImageCache sharedImageCache] getSize] / 1024 /1024;
    NSString *clearCacheSizeStr;
    if(cacheSize >= 1){
        clearCacheSizeStr = [NSString stringWithFormat:@"%.1fM",cacheSize];
    }else{
        clearCacheSizeStr = [NSString stringWithFormat:@"%.1fK",cacheSize * 1024];
    }
    return clearCacheSizeStr;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
                //跳转到收藏界面
                [self pushToCollectPage];
                break;
            case 1:
                //跳转到项目主页
                [self pushToWebView:MNGitHubIOSGankMM WithTitle:@"项目GitHub主页"];
                break;
            case 2:
                //推荐Android
                [self pushToWebView:MNGitHubAndroidGankMM WithTitle:@"Android干货客户端"];
                break;
        }
    }else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                //清楚缓存
                [self showCleanAlert];
                break;
            case 1:
                //跳转关于界面
                [self pushToAboutPage];
                break;
        }
    }
    
    //还原TableView选中状态
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
}

-(void)showCleanAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"缓存清除" message:@"确定要清除图片缓存吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self cleanCacheApp];
    }];
    
    UIAlertAction *action2= [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:nil];

}

-(void)cleanCacheApp
{
    //清楚缓存
    [[SDImageCache sharedImageCache] clearDisk];
    
    //删除数据库
    [MNGankDao deleteCacheWithType:@"福利"];
    
    [MyProgressHUD showToast:@"清除完成"];
    
    [self.tableView reloadData];
    
}

-(void)pushToCollectPage
{
    MNCollectViewController *collectVc = [[MNCollectViewController alloc] init];
    [self.navigationController pushViewController:collectVc animated:YES];
}

-(void)pushToWebView:(NSString *)url WithTitle:(NSString *)title
{
    //跳转WebView
    MNWebViewController *webViewVc = [[MNWebViewController alloc] init];
    webViewVc.url = url;
    webViewVc.mTitle = title;
    [self.navigationController pushViewController:webViewVc animated:YES];
}


-(void)pushToAboutPage
{
    MNAboutViewController *aboutVc = [[MNAboutViewController alloc] init];
    [self.navigationController pushViewController:aboutVc animated:YES];
}


@end
