//
//  ViewController.m
//  daojishi
//
//  Created by HuiDong Shi on 2017/4/17.
//  Copyright © 2017年 HuiDongShi. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"

@interface ViewController ()<UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)NSInteger time;
@property (nonatomic, strong)NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.time =0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
//    [[NSRunLoop currentRunLoop] run];
}
- (void)timeDown{
    self.time ++;
    NSLog(@"%zd", self.time);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TableViewCell class]) forIndexPath:indexPath];
    
    cell.min = (indexPath.row + 1) * 60 - self.time;
    
    return cell;
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = self.view.frame;
        _tableView.dataSource = self;
        [_tableView registerClass:[TableViewCell class] forCellReuseIdentifier:NSStringFromClass([TableViewCell class])];
    }
    return _tableView;
}

@end
