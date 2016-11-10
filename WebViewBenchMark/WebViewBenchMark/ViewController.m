//
//  ViewController.m
//  WebViewBenchMark
//
//  Created by dequanzhu on 2016/11/7.
//  Copyright © 2016年 dequanzhu. All rights reserved.
//

#import "ViewController.h"
#import "BenchMark_WebView.h"
#import "BenchMark_LoadLocalFile.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong,readwrite)UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:({
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView;
    })];
}


#pragma mark - UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ({
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        cell.textLabel.text = (indexPath.row == 0)?@"webView":@"localFile";
        cell;
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        BenchMark_WebView *controller = [[BenchMark_WebView alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        BenchMark_LoadLocalFile *controller = [[BenchMark_LoadLocalFile alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

@end


