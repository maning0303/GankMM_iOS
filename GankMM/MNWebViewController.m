//
//  MNWebViewController.m
//  GankMM
//
//  Created by 马宁 on 16/5/10.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import "MNWebViewController.h"
#import "GankModel.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "LrdOutputView.h"
#import "MNUtils.h"
#import "MNGankDao.h"

@interface MNWebViewController () <UIWebViewDelegate,NJKWebViewProgressDelegate,LrdOutputViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolBarGoBack;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolBarGoForward;

@property(nonatomic,strong)NJKWebViewProgressView *webViewProgressView;

@property(nonatomic,strong)NJKWebViewProgress *webViewProgress;

@property (nonatomic, strong) NSArray *moreBtnArrays;
@property (nonatomic, strong) LrdOutputView *outputView;

@end

@implementation MNWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavigation];
    
    [self initWebView];
    
    [self initMoreBtn];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MNWebViewController"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MNWebViewController"];
}

-(void)initMoreBtn
{
    LrdCellModel *one = [[LrdCellModel alloc] initWithTitle:@"复制链接" imageName:@""];
    LrdCellModel *two = [[LrdCellModel alloc] initWithTitle:@"浏览器打开" imageName:@""];
    
    //判断需不需要展示收藏选项
    if (_gankModel != nil) {
        //判断是不是收藏过
        LrdCellModel *three;
        if(_gankModel.collect){
            three = [[LrdCellModel alloc] initWithTitle:@"取消收藏" imageName:@""];
        }else{
            three = [[LrdCellModel alloc] initWithTitle:@"添加收藏" imageName:@""];
        }
        self.moreBtnArrays = @[one,two,three];
    }else{
        self.moreBtnArrays = @[one,two];
    }
}

-(void)setNavigation
{
    
    self.navigationController.navigationBar.hidden=NO;
    
    self.navigationItem.title = @"网页";
    if(_gankModel==nil){
        if(_mTitle!=nil && _mTitle.length > 0){
            self.navigationItem.title = _mTitle;
        }
    }else{
        self.navigationItem.title = _gankModel.desc;
    }
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"gank_more_vert" highImage:@"gank_more_vert" target:self action:@selector(rightClick)];
    
    //状态栏设置
    [[MNTopWindowController shareInstance] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)rightClick
{
    MNLogFunc;
    
    _outputView = [[LrdOutputView alloc] initWithDataArray:self.moreBtnArrays origin:CGPointMake(MNScreenW - 10, 66) width:125 height:44 direction:kLrdOutputViewDirectionRight];
    _outputView.delegate = self;
    _outputView.dismissOperation = ^(){
        //设置成nil，以防内存泄露
        _outputView = nil;
    };
    [_outputView pop];

}

-(void)initWebView
{
    
    //距离顶部的调整
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    //WebView
    self.webViewProgress = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = self.webViewProgress;
    self.webViewProgress.webViewProxyDelegate = self;
    self.webViewProgress.progressDelegate = self;
    CGRect navBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0,
                                 navBounds.size.height - 2,
                                 MNScreenW,
                                 2);
    _webViewProgressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _webViewProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_webViewProgressView setProgress:0 animated:YES];
    [self.navigationController.navigationBar addSubview:_webViewProgressView];
    
    NSString *newUrl;
    if(_gankModel==nil){
        newUrl = _url;
    }else{
        newUrl = _gankModel.url;
    }
    NSString *url = [newUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
    
}

-(void)updateState
{

    if([self.webView canGoBack]){
        self.toolBarGoBack.enabled = YES;
    }else{
        self.toolBarGoBack.enabled = NO;
    }
    if([self.webView canGoForward]){
        self.toolBarGoForward.enabled = YES;
    }else{
        self.toolBarGoForward.enabled = NO;
    }
}

- (IBAction)goBack:(id)sender {
    if([self.webView canGoBack]){
        [self.webView goBack];
    }
}
- (IBAction)goForward:(id)sender {
    if([self.webView canGoForward]){
        [self.webView goForward];
    }
}
- (IBAction)refresh:(id)sender {
    [self.webView reload];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self updateState];
    _webViewProgressView.hidden = NO;
    [_webViewProgressView setProgress:0 animated:NO];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self updateState];
    _webViewProgressView.hidden = YES;
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self updateState];
    _webViewProgressView.hidden = YES;
}

-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    if (progress == NJKInteractiveProgressValue) {
        [_webViewProgressView setProgress:100 animated:YES];
        _webViewProgressView.hidden = YES;
    }else{
        [self.webViewProgressView setProgress:progress animated:YES];
    }
}

-(void)dealloc
{
    _webViewProgressView.hidden = YES;
}

//---------代理
-(void)didSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            if(_gankModel==nil){
                [MNUtils saveToPasteboard:_url];
            }else{
                [MNUtils saveToPasteboard:_gankModel.url];
            }
            
            [MyProgressHUD showToast:@"复制链接成功"];
            break;
        case 1:
            if(_gankModel==nil){
                [MNUtils openURLWithBrowser:_url];
            }else{
                [MNUtils openURLWithBrowser:_gankModel.url];
            }
            
            break;
        case 2:
            if(_gankModel == nil){
                return;
            }
            if(_gankModel.collect){
                //删除数据库数据
                BOOL result = [MNGankDao deleteOne:_gankModel._id];
                if(result){
                    _gankModel.collect = NO;
                    [MyProgressHUD showToast:@"取消收藏成功"];
                }else{
                    [MyProgressHUD showToast:@"取消收藏失败"];
                }
            }else{
                //插入数据库
                BOOL result = [MNGankDao save:_gankModel];
                if(result){
                    _gankModel.collect = YES;
                    [MyProgressHUD showToast:@"收藏成功"];
                }else{
                    [MyProgressHUD showToast:@"收藏失败"];
                }
            }
            //更新弹框
            [self initMoreBtn];
            
            break;
    }
}

@end
