//
//  ViewController.m
//  SCRScrollMenuControllerDemo
//
//  Created by Joe Shang on 12/9/14.
//  Copyright (c) 2014 Shang Chuanren. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SCRScrollMenuController.h"
#import "topTableViewController.h"
#import "shehuiTableViewController.h"
#import "guoneiTableViewController.h"
#import "guojiTableViewController.h"
#import "yuleTableViewController.h"
#import "tiyuTableViewController.h"
#import "junshiTableViewController.h"
#import "kejiTableViewController.h"
#import "caijingTableViewController.h"
#import "shishangTableViewController.h"

@interface ViewController ()

@property (nonatomic, strong) SCRScrollMenuController *scrollMenuController;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.scrollMenuController = [[SCRScrollMenuController alloc] init];
    // 设置新闻导航栏高度
    self.scrollMenuController.scrollMenuHeight = 65;
    // 设置新闻导航栏背景颜色
    self.scrollMenuController.scrollMenuBackgroundColor = [UIColor colorWithRed:0 green:191/255.0 blue:1 alpha:1.0];
    // 设置新闻导航栏导航条颜色
    self.scrollMenuController.scrollMenuIndicatorColor = [UIColor whiteColor];
    // 设置新闻导航栏导航条高度
    self.scrollMenuController.scrollMenuIndicatorHeight = 3;
    // 设置新闻导航栏导航按钮大小
    self.scrollMenuController.scrollMenuButtonPadding = 15;
    // 设置新闻导航栏——默认字体大小
    self.scrollMenuController.normalTitleAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:19],
                                                        NSForegroundColorAttributeName: [UIColor blackColor]};
    // 设置新闻导航栏——选中字体大小
    self.scrollMenuController.selectedTitleAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:19],
                                                        NSForegroundColorAttributeName: [UIColor whiteColor]};
    // 设置视图位置
    self.scrollMenuController.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    // 自动调整视图位置，关于UIView的autoresizingMask属性详见http://www.cnblogs.com/jiangyazhou/archive/2012/06/26/2563041.html
    self.scrollMenuController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.scrollMenuController didMoveToParentViewController:self];
    // 设置导航标题内容
    NSArray *titles = @[@"头条", @"社会", @"国内", @"国际", @"娱乐", @"体育", @"军事", @"科技", @"财经", @"时尚"];
    // 设置导航视图控制器集合容器大小
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:[titles count]];
    // 设置导航栏标题内容集合容器大小
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:[titles count]];
   
    // 头条
    topTableViewController *top = [[topTableViewController alloc] init];
    [viewControllers addObject:top];
    SCRScrollMenuItem *item0 = [[SCRScrollMenuItem alloc] init];
    item0.title = [titles objectAtIndex:0];
    [items addObject:item0];
    
    // 社会
    shehuiTableViewController *shehui = [[shehuiTableViewController alloc] init];
    [viewControllers addObject:shehui];
    SCRScrollMenuItem *item1 = [[SCRScrollMenuItem alloc] init];
    item1.title = [titles objectAtIndex:1];
    [items addObject:item1];
    
    // 国内
    guoneiTableViewController *guonei = [[guoneiTableViewController alloc] init];
    [viewControllers addObject:guonei];
    SCRScrollMenuItem *item2 = [[SCRScrollMenuItem alloc] init];
    item2.title = [titles objectAtIndex:2];
    [items addObject:item2];
    
    // 国际
    guojiTableViewController *guoji = [[guojiTableViewController alloc] init];
    [viewControllers addObject:guoji];
    SCRScrollMenuItem *item3 = [[SCRScrollMenuItem alloc] init];
    item3.title = [titles objectAtIndex:3];
    [items addObject:item3];
    
    // 娱乐
    yuleTableViewController *yule = [[yuleTableViewController alloc] init];
    [viewControllers addObject:yule];
    SCRScrollMenuItem *item4 = [[SCRScrollMenuItem alloc] init];
    item4.title = [titles objectAtIndex:4];
    [items addObject:item4];
   
    // 体育
    tiyuTableViewController *tiyu = [[tiyuTableViewController alloc] init];
    [viewControllers addObject:tiyu];
    SCRScrollMenuItem *item5 = [[SCRScrollMenuItem alloc] init];
    item5.title = [titles objectAtIndex:5];
    [items addObject:item5];
   
    // 军事
    junshiTableViewController *junshi = [[junshiTableViewController alloc] init];
    [viewControllers addObject:junshi];
    SCRScrollMenuItem *item6 = [[SCRScrollMenuItem alloc] init];
    item6.title = [titles objectAtIndex:6];
    [items addObject:item6];
   
    // 科技
    kejiTableViewController *keji = [[kejiTableViewController alloc] init];
    [viewControllers addObject:keji];
    SCRScrollMenuItem *item7 = [[SCRScrollMenuItem alloc] init];
    item7.title = [titles objectAtIndex:7];
    [items addObject:item7];
    
    // 财经
    caijingTableViewController *caijing = [[caijingTableViewController alloc] init];
    [viewControllers addObject:caijing];
    SCRScrollMenuItem *item8 = [[SCRScrollMenuItem alloc] init];
    item8.title = [titles objectAtIndex:8];
    [items addObject:item8];
   
    // 时尚
    shishangTableViewController *shishang = [[shishangTableViewController alloc] init];
    [viewControllers addObject:shishang];
    SCRScrollMenuItem *item9 = [[SCRScrollMenuItem alloc] init];
    item9.title = [titles objectAtIndex:9];
    [items addObject:item9];
    
    // 添加相关内容进视图控制器和导航栏内容集合
    [self.scrollMenuController setViewControllers:viewControllers withItems:items];
    
    // 设置导航视图控制器（SCRScrollMenuController只是一个视图view，需要我们加入到导航视图控制器中）
    UINavigationController *mainNC = [[UINavigationController alloc] initWithRootViewController:self.scrollMenuController];
    mainNC.navigationBar.backgroundColor = [UIColor blackColor];
    // 隐藏导航条
    mainNC.navigationBar.hidden = YES;
    [self addChildViewController:mainNC];
    [self.view addSubview:mainNC.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
