//
//  SYJListController.m
//  RecordPen
//
//  Created by 尚勇杰 on 2017/8/2.
//  Copyright © 2017年 尚勇杰. All rights reserved.
//

#import "SYJListController.h"
#import "SYJRecordCell.h"
#import "SYJPlayerController.h"

@interface SYJListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, strong) NSMutableArray *listTimeArr;
@property (nonatomic, strong) NSMutableArray *sizeArr;



@end

@implementation SYJListController

- (NSMutableArray *)sizeArr{
    
    if (_sizeArr == nil) {
        _sizeArr = [NSMutableArray array];
    }
    
    return _sizeArr;
    
}


- (NSMutableArray *)listArr{
    
    if (_listArr == nil) {
        _listArr = [NSMutableArray array];
    }
    
    return _listArr;
    
}

- (NSMutableArray *)listTimeArr{
    
    if (_listTimeArr == nil) {
        _listTimeArr = [NSMutableArray array];
    }
    
    return _listTimeArr;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = [UILabel titleWithColor:[UIColor whiteColor] title:@"Recording File" font:16.0];
    
    [self setTableView];
    
    NSFileManager *fileManage = [NSFileManager defaultManager];
    
    NSString *myDirectory = [documentPath stringByAppendingPathComponent:@"/FilePath"];
    
    self.listArr = [[fileManage subpathsOfDirectoryAtPath: myDirectory error:nil] mutableCopy];
    
    for (NSString *path in self.listArr) {
        NSString *pathName = [NSString stringWithFormat:@"/FilePath/%@",path];
        NSString *docPath = [documentPath stringByAppendingPathComponent:pathName];
        NSDictionary *fileAttributes = [fileManage attributesOfItemAtPath:docPath error:nil];
        NSString *size = fileAttributes[NSFileSize];
        NSDate *timeCerat = fileAttributes[NSFileCreationDate];

        [self.listTimeArr addObject:timeCerat];
        [self.sizeArr addObject:size];
        
    }
    
    

    
    // Do any additional setup after loading the view.
}

- (void)setTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerClass:[SYJRecordCell class] forCellReuseIdentifier:@"cell"];
}


#pragma mark - table view dataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 75;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SYJRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.nameLab.text = [NSString stringWithFormat:@"%@",self.listArr[indexPath.row]];
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = self.listTimeArr[indexPath.row];
   
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSInteger interval = [timeZone secondsFromGMTForDate:date];
    NSDate *localeDate = [date  dateByAddingTimeInterval:interval];

    cell.timeLab.text = [dateFormat stringFromDate:localeDate];
    float size = [self.sizeArr[indexPath.row] floatValue];
    float sizeMb = size / 1024 / 1024;
    cell.sizeLab.text = [NSString stringWithFormat:@"%.2fMb",sizeMb];
    
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SYJRecordCell *cell = (SYJRecordCell *)[tableView cellForRowAtIndexPath:indexPath];
    SYJPlayerController *vc = [[SYJPlayerController alloc]init];
    vc.fileName = [NSString stringWithFormat:@"/FilePath/%@",cell.nameLab.text];
    [self.navigationController pushViewController:vc animated:YES];
    
    
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
