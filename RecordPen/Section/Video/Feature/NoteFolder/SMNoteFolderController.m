//
//  SMNoteFolderController.m
//  SMNote
//
//  Created by SimonMiao on 16/8/9.
//  Copyright © 2016年 MSY. All rights reserved.
//

#import "SMNoteFolderController.h"
#import "SMDeleteAlertController.h"
#import "SMNoteFolderView.h"
#import "SMNoteFolderBottomView.h"
#import "SMNoteFolderAdapter.h"
#import "SMNoteFolderInteractor.h"

#import <Masonry/Masonry.h>

#import "SMNoteFolderModel.h"
#import "ATCommonCellModel.h"

#import "SMDaoFactory.h"

@interface SMNoteFolderController () <ATTableViewAdapterDelegate>
{
    UIAlertAction *_sureAction;
}

@property (nonatomic, strong) SMNoteFolderView *folderView;
@property (nonatomic, strong) SMNoteFolderAdapter *adapter;
@property (nonatomic, strong) SMNoteFolderInteractor *interactor;
@property (nonatomic, strong) SMNoteFolderBottomView *bottomView;

@end

@implementation SMNoteFolderController

- (SMNoteFolderInteractor *)interactor {
    if (!_interactor) {
        _interactor = [[SMNoteFolderInteractor alloc] init];
        _interactor.baseController = self;
    }
    
    return _interactor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [UILabel titleWithColor:[UIColor whiteColor] title:@"Note" font:17.0];
    
    self.bottomView = [[SMNoteFolderBottomView alloc] init];
//    self.folderView = [[SMNoteFolderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44)];
    self.folderView = [[SMNoteFolderView alloc] init];
    [self.view addSubview:self.folderView];
    [self.view addSubview:self.bottomView];
    
    [self.folderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(44);
        make.bottom.with.offset(-44);
    }];
    
    self.adapter = [[SMNoteFolderAdapter alloc] init];
    self.adapter.adapterDelegate = self;
    [self.folderView setTableViewAdapter:self.adapter];
    
    [self createRightItem];
    [self loadDataSource];
    
    ATWeakSelf
    [self.bottomView BottomViewBtnClickedWithBlock:^(SMBottomViewBtnType type) {
        if (type == SMBottomViewBtnTypeCreate) {
            [weakSelf popAlertView:@""];
        } else if (type == SMBottomViewBtnTypeOfDelete) {
            BOOL isEmptyFolder = YES;
            for (SMNoteFolderModel *folder in weakSelf.adapter.deleteArray) {
                if (folder.number.integerValue) {
                    isEmptyFolder = NO;
                    break;
                }
            }
            if (isEmptyFolder) {
                //删除这些空文件夹
                [[_Dao getFolderDao] removeFolders:[weakSelf.adapter.deleteArray copy] async:YES];
                [weakSelf removeDeleteArrayAndReloadRow];
            } else {
                SMDeleteAlertController *ctr = [SMDeleteAlertController alertControllerWithTitle:@"Delete folders?"
                                                                                         message:@"If only this folder is deleted, the memo will be moved to the folder. Subfolders will also be deleted."
                                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
                ctr.deleteArray = [weakSelf.adapter.deleteArray copy];
                [ctr deleteAlertActionClick:^(SMDeleteAlertActionType type) {
                    switch (type) {
                        case SMDeleteAlertActionTypeDeleteFolderAndNotes: {
                            NSInteger i = 0;
                            for (SMNoteFolderModel *folder in weakSelf.adapter.deleteArray) {
                                i += folder.number.integerValue;//计算deleteArray中的备忘录数量
                            }
                            if (i) {
                                SMNoteFolderModel *lastObj = [weakSelf.adapter.adapterArray lastObject];
                                if (0 == lastObj.order.integerValue) {
                                    lastObj.number = @(lastObj.number.integerValue + i);
                                } else {
                                    SMNoteFolderModel *trash = [[SMNoteFolderModel alloc] init];
                                    trash.title = @"Recently deleted";
                                    trash.number = @(i);
                                    [weakSelf.adapter.adapterArray addObject:trash];
                                }
                            }
                            [weakSelf removeDeleteArrayAndReloadRow];
                            break;
                        }
                        case SMDeleteAlertActionTypeDeleteFolderOnly:
                            
                            break;
                            
                        default:
                            break;
                    }
                }];
                [weakSelf presentViewController:ctr animated:YES completion:nil];
            }
        }
    }];
    [self.adapter modifyFolderName:^(NSString *title) {
        [weakSelf popAlertView:title];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self loadDataSource];
}

- (void)createRightItem {
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClicked:)];
    rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightItem;
}

/** 删除对应行，刷新对应行的cell,Dao层处理数据不在此做 */
- (void)removeDeleteArrayAndReloadRow {
    NSMutableArray *deletePathArr = [NSMutableArray arrayWithCapacity:self.adapter.deleteArray.count];
    for (SMNoteFolderModel *folder in self.adapter.deleteArray) {
        NSUInteger index = [self.adapter.adapterArray indexOfObject:folder];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [deletePathArr addObject:indexPath];
    }
    [self.adapter.adapterArray removeObjectsInArray:self.adapter.deleteArray];
    [self.folderView.dataTableView deleteRowsAtIndexPaths:deletePathArr withRowAnimation:UITableViewRowAnimationRight];
    [self.adapter.deleteArray removeAllObjects];
}

- (void)loadDataSource {
    NSMutableArray *dataSource = [NSMutableArray arrayWithCapacity:0];
    
    ATTitleCellModel *titleModel = [[ATTitleCellModel alloc] init];
    titleModel.title = @"My iPhone";
    titleModel.titleColor = [UIColor at_blackColor];
    [dataSource addObject:titleModel];
    
    NSArray *folders = [[_Dao getFolderDao] loadAllFolders];
    [dataSource addObjectsFromArray:folders];
    NSArray *trashMemos = [[_Dao getTrashFolderDao] loadAllTrashMemosFromDB];
    if (trashMemos.count) {
        SMNoteFolderModel *model = [[SMNoteFolderModel alloc] init];
        
//        SMNoteTrashFolderModel *model = [[SMNoteTrashFolderModel alloc] init];
        model.title = @"Recently deleted";
        model.number = @(trashMemos.count);
        model.order = @(0);
//        model.menos = trashMemos;
        [dataSource addObject:model];
    }
    
    self.adapter.adapterArray = dataSource;
    [self.folderView refreshTableView];
}

- (void)rightItemClicked:(UIBarButtonItem *)item {
    item.title = self.folderView.dataTableView.editing ? @"Edit" : @"Finsh";
    [self.adapter.deleteArray removeAllObjects];
    [self.folderView.dataTableView setEditing:!self.folderView.dataTableView.editing animated:YES];
    
    [self.bottomView notifyTheBtnChangeStatus:self.folderView.dataTableView.editing];
}

- (void)popAlertView:(NSString *)tfText {
    UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"New File"
                                                                      message:@"Please enter a name for this folder"
                                                               preferredStyle:UIAlertControllerStyleAlert];
    ATWeakSelf
    [alertCtr addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"name";
        textField.text = tfText.length ? tfText : @"";
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleTextFieldTextDidChangeNotification:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:textField];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancle"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf removeCurrentObserver:alertCtr];
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"save"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf removeCurrentObserver:alertCtr];
        SMNoteFolderModel *model = [[SMNoteFolderModel alloc] init];
        model.title = alertCtr.textFields.firstObject.text;
        model.number = [NSNumber numberWithUnsignedInteger:0];
        long long timestamp = [[NSDate date] timeIntervalSince1970];
        model.order = [NSNumber numberWithLongLong:timestamp];
        [weakSelf.adapter.adapterArray insertObject:model atIndex:1];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [weakSelf.folderView.dataTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [[_Dao getFolderDao] insertFolder:model async:YES];
    }];
    sureAction.enabled = NO;
    _sureAction = sureAction;
    
    [alertCtr addAction:cancelAction];
    [alertCtr addAction:sureAction];
    
    [self presentViewController:alertCtr animated:YES completion:nil];
}

- (void)removeCurrentObserver:(UIAlertController *)alertCtr {
//    [alertCtr resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:alertCtr.textFields.firstObject];
}

- (void)handleTextFieldTextDidChangeNotification:(NSNotification *)notification {
    UITextField *textField = notification.object;
    _sureAction.enabled = textField.text.length > 0 ? YES : NO;
}

#pragma mark - ATTableViewAdapterDelegate
- (void)didSelectCellData:(id)cellData index:(NSIndexPath *)indexPath
{
    if ([cellData isKindOfClass:[SMNoteFolderModel class]]) {
        SMNoteFolderModel *model = (SMNoteFolderModel *)cellData;
//        if (0 == model.order.integerValue) {
//            if (!self.folderView.dataTableView.editing) {
//                
//                [self.interactor goToNoteMemoPageNoteFolderModel:cellData];
//            }
//        } else {
            if (self.folderView.dataTableView.editing) {
                [self.adapter.deleteArray addObject:self.adapter.adapterArray[indexPath.row]];
                ATLog(@"编辑状态的cell被点击了");
                [self.bottomView modifyTheBtnEnabledWithDeleteArrCount:self.adapter.deleteArray.count];
            } else {
                //不处于编辑状态
//                __block SMNoteFolderModel *folderModel = cellData;
                ATWeakSelf
                [self.interactor returnNoteMemoNumber:^(NSUInteger memoNum) {
                    if (model.number.integerValue != memoNum) {
                        if (0 != model.order.integerValue ) {
                            model.number = @(memoNum);
                            [[_Dao getFolderDao] insertFolder:model async:YES];
                            
                        } else {
                            model.number = @(memoNum);
                            ATLog(@"废纸篓被点击啦");
                        }
                        NSUInteger index = [weakSelf.adapter.adapterArray indexOfObject:model];
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                        [weakSelf.folderView.dataTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    }
                }];
                [self.interactor goToNoteMemoPageNoteFolderModel:cellData];
            }
//        }
    }
}

- (void)didDeselectCellData:(id)cellData index:(NSIndexPath *)indexPath
{
    if ([cellData isKindOfClass:[SMNoteFolderModel class]]) {
        if (self.folderView.dataTableView.editing) {
            [self.adapter.deleteArray removeObject:cellData];
            [self.bottomView modifyTheBtnEnabledWithDeleteArrCount:self.adapter.deleteArray.count];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self resignFirstResponder];
    [Notif removeObserver:self];
}

@end
