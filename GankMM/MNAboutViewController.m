//
//  MNAboutViewController.m
//  GankMM
//
//  Created by 马宁 on 16/5/11.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import "MNAboutViewController.h"
#import "MNWebViewController.h"
#import "MNUtils.h"

@interface MNAboutViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lableVersion;
@property (weak, nonatomic) IBOutlet UILabel *lableAppName;

@end

@implementation MNAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavigation];
    
    [self initViews];
    
    [self initData];
    
}


-(void)setNavigation
{
    self.navigationItem.title = @"关于";
    //状态栏设置
    [[MNTopWindowController shareInstance] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)initViews
{
    //不自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

-(void)initData
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    MNLog(@"---infoDictionary---%@",infoDictionary);
    
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    self.lableVersion.text = [NSString stringWithFormat:@"版本：%@",app_Version];
    self.lableAppName.text = app_Name;
}

//-------------------------点击事件
- (IBAction)btn_github:(id)sender {
    //打开WebView，展示我的gitHub主页
    if (YES) {
        [self goWebView:MNGitHub];
    }else{  //通过浏览器打开

    }
    
}
- (IBAction)btn_gank:(id)sender {
    //跳转到干货集中营首页
    if (YES) {
        [self goWebView:MNGankio];
    }else{  //通过浏览器打开

    }
}

-(void)goWebView:(NSString *)url
{
    //跳转WebView
    MNWebViewController *webViewVc = [[MNWebViewController alloc] init];
    webViewVc.url = url;
    [self.navigationController pushViewController:webViewVc animated:YES];
}

//-------Shake 测试代码---------
//-(BOOL)canBecomeFirstResponder{
//    return YES;
//}
//
//-(void)viewDidAppear:(BOOL)animated{
//    [self canBec  omeFirstResponder];
//}
//
//#pragma mark -
//#pragma mark - MotionShake Event
//-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
//    
//}
//
//-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
//    if(motion == UIEventSubtypeMotionShake){
//        NSLog(@"Shake!!!!!!!!!!!");
//    }
//}
//
//-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
//    
//}


@end
