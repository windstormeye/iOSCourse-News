//
//  yuleTableViewController.m
//  News
//
//  Created by #incloud on 17/2/8.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "yuleTableViewController.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface yuleTableViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) NSMutableArray *picArr;
@property (nonatomic, strong) NSMutableArray *urlArr;
@property (nonatomic, strong) NSMutableArray *dateArr;
@property (nonatomic, strong) NSMutableArray *aothorArr;
@end

@implementation yuleTableViewController
{
    int cellCount;
}

- (NSMutableArray *)titleArr
{
    if (!_titleArr)
    {
        _titleArr = [[NSMutableArray alloc] init];
    }
    return _titleArr;
}

- (NSMutableArray *)picArr
{
    if (!_picArr)
    {
        _picArr = [[NSMutableArray alloc] init];
    }
    return _picArr;
}

- (NSMutableArray *)urlArr
{
    if (!_urlArr)
    {
        _urlArr = [[NSMutableArray alloc] init];
    }
    return _urlArr;
}

- (NSMutableArray *)dateArr
{
    if (!_dateArr)
    {
        _dateArr = [[NSMutableArray alloc] init];
    }
    return _dateArr;
}

- (NSMutableArray *)aothorArr
{
    if (!_aothorArr)
    {
        _aothorArr = [[NSMutableArray alloc] init];
    }
    return _aothorArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView reloadData];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self loadNewData];
    }];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadNewData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:@"http://v.juhe.cn/toutiao/index" parameters:@{@"type" : @"yule",
            @"key" : @"32711a68c8cdc2157821b2965014da0e"} progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"请求成功:%@", responseObject);
                
                NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    for (int i = 0; i < [JSON[@"result"][@"data"] count]; i++)
                    {
                        [self.titleArr addObject:JSON[@"result"][@"data"][i][@"title"]];
                        [self.picArr addObject:JSON[@"result"][@"data"][i][@"thumbnail_pic_s"]];
                        [self.urlArr addObject:JSON[@"result"][@"data"][i][@"url"]];
                        [self.dateArr addObject:JSON[@"result"][@"data"][i][@"date"]];
                        [self.aothorArr addObject:JSON[@"result"][@"data"][i][@"author_name"]];
                    }
                    cellCount = (int)[JSON[@"result"][@"data"] count];
                    
                    [self.tableView reloadData];
                    [self.tableView.mj_header endRefreshing];
                });
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                NSLog(@"请求失败:%@", error.description);
            }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cellCount;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 定义唯一标识
    static NSString *CellIdentifier = @"Cell";
    // 通过唯一标识创建cell实例
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    else//当页面拉动的时候 当cell存在并且最后一个存在 把它进行删除就出来一个独特的cell我们在进行数据配置即可避免
    {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    //    cell.textLabel.text = self.titleArr[indexPath.row];
    float imgH = cell.frame.size.height * 0.8;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, (cell.frame.size.height - imgH) / 2, self.view.frame.size.width * 0.3, imgH)];
    [imgView sd_setImageWithURL:[NSURL URLWithString:self.picArr[indexPath.row]]
               placeholderImage:[UIImage imageNamed:@"placeholder"]];
    imgView.contentMode =UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    [cell.contentView addSubview:imgView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame) + 5, imgView.frame.origin.y, cell.frame.size.width - CGRectGetMaxX(imgView.frame) - 5, 50)];
    titleLabel.text = self.titleArr[indexPath.row];
    titleLabel.numberOfLines = 0;
    [cell.contentView addSubview:titleLabel];
    
    float dateH = 10;
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, CGRectGetMaxY(imgView.frame) - dateH, 120, dateH)];
    dateLabel.font = [UIFont systemFontOfSize:14];
    dateLabel.text = self.dateArr[indexPath.row];
    dateLabel.textColor = [UIColor grayColor];
    [cell.contentView addSubview:dateLabel];
    
    UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(dateLabel.frame) - 5, dateLabel.frame.origin.y, 95, dateLabel.frame.size.height)];
    authorLabel.font = [UIFont systemFontOfSize:14];
    authorLabel.textAlignment = UITextAlignmentRight;
    authorLabel.text = self.aothorArr[indexPath.row];
    authorLabel.textColor = [UIColor grayColor];
    [cell.contentView addSubview:authorLabel];
    
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *webVC = [[UIViewController alloc] init];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height + 54)];
    webView.backgroundColor = [UIColor whiteColor];
    webVC.view.backgroundColor = [UIColor whiteColor];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlArr[indexPath.row]]];
    [webVC.view addSubview: webView];
    [webView loadRequest:request];
    [self.navigationController pushViewController:webVC animated:YES];
}

// 解决分割线问题
- (void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
