
//
//  SYJMineController.m
//  RecordPen
//
//  Created by 尚勇杰 on 2017/8/4.
//  Copyright © 2017年 尚勇杰. All rights reserved.
//

#import "SYJMineController.h"
#import "SYJMineCell.h"
#import "YJCache.h"
#import "SYJAboutController.h"
#import "SYJListController.h"
#import "SYJShareFileController.h"
#import "SettingVC.h"

@interface SYJMineController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *arrList;
@property (nonatomic, strong) NSArray *imageArr;

@end

@implementation SYJMineController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrList = @[@"The recording file",@"File sharing",@"About Us",@"Clean up the memory",@"Set the password"];
    self.imageArr = @[@"录音",@"导出",@"关于",@"清理",@"密码"];
    
    [self setTableView];
    
    // Do any additional setup after loading the view.
}

- (void)setTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = Gray;
    
    [self.tableView registerClass:[SYJMineCell class] forCellReuseIdentifier:@"cell"];
    
}

#pragma mark - table view dataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SYJMineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.img.image = [UIImage imageNamed:self.imageArr[indexPath.section]];
    cell.nameLab.text = self.arrList[indexPath.section];
    cell.access.image = [UIImage imageNamed:@"Access"];
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            [self.navigationController pushViewController:[SYJListController new] animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:[SYJShareFileController new] animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:[SYJAboutController new] animated:YES];
            break;
        case 3:{
            
            
            float cache = [YJCache filePath];
            NSString *str = [NSString stringWithFormat:@"清理了%.2f Mb 缓存",cache];
            [YJCache clearFile];
            [SVProgressHUD showInfoWithStatus:str];
        }
            break;
        case 4:{
            
            [self.navigationController pushViewController:[SettingVC new] animated:YES];
            
            
        }
            break;
            
        default:
            break;
    }
    
//    kTipAlert(@"<%ld> selected...", indexPath.row);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
