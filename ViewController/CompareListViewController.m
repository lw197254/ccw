//
//  CompareListViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2017/2/17.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "CompareListViewController.h"
#import "CompareListTableViewCell.h"
#import "SelectCarTypeViewController.h"
#import "ParameterConfigViewController.h"
#import "BrandViewController.h"
#import "CompareDict.h"
#import "DialogView.h"

#import "NewCompareCarViewController.h"
@interface CompareListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewButtonToSuperViewConstraint;
@property (weak, nonatomic) IBOutlet UIButton *compareButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
//@property (strong, nonatomic) UIButton *addButton;
@property (strong, nonatomic) UIButton *selectAllButton;
@property (strong, nonatomic) UIButton *editButton;
//@property (strong, nonatomic) NSMutableArray *compareSelectedArray;
//@property (strong, nonatomic) NSArray *[CompareDict shareInstance].dict.allValue;
@property (weak, nonatomic) IBOutlet UIView *compareButtonTopLine;
//@property (strong, nonatomic) NSMutableArray *editSelectedArray;
//@property (strong, nonatomic) NSMutableDictionary *dataDict;
@property (strong, nonatomic) NSMutableDictionary *compareSelectedDict;

@property (strong, nonatomic) NSMutableDictionary *editSelectedDict;
@property (assign, nonatomic) NSInteger editSelectedDictCount;
@property (assign, nonatomic) NSInteger compareSelectedDictCount;
@property (assign, nonatomic) NSInteger compareAllDictCount;
@property (assign, nonatomic) BOOL isEdit;

@property (weak, nonatomic) IBOutlet UIButton *addCarButton;

@end

@implementation CompareListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showNavigationTitle:@"车型对比"];
    [self.tableView registerNib:nibFromClass(CompareListTableViewCell) forCellReuseIdentifier:classNameFromClass(CompareListTableViewCell)];
    
//    [self.[CompareDict shareInstance].dict.allValue enumerateObjectsUsingBlock:^(FindCarByGroupByCarTypeGetCarModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [[CompareDict shareInstance].dict setValue:obj forKey:obj.car_id];
//    }];
    
    [self showRightButton];
    
    ///设置按钮背景色
    [self.compareButton setBackgroundImage:[UIImage imageWithColor:BlueColor447FF5] forState:UIControlStateNormal];
    [self.deleteButton setBackgroundImage:[UIImage imageWithColor:RedColorFE5050] forState:UIControlStateNormal];
    [self.compareButton setBackgroundImage:[UIImage imageWithColor:BlackColor999999]forState:UIControlStateDisabled];
    [self.deleteButton setBackgroundImage:[UIImage imageWithColor:RedColorFF9B9B] forState:UIControlStateDisabled];
    

    
    self.tableView.tableFooterView = [[UIView alloc]init];

    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)setIsEdit:(BOOL)isEdit{
    if (_isEdit!=isEdit) {
        _isEdit = isEdit;
        if (isEdit) {
            [self showBarButton:NAV_LEFT title:@"取消" fontColor:BlackColor333333];
            
            [self showSelectAllButton];
           
            self.deleteButton.hidden = NO;
            self.compareButton.hidden = YES;
            self.compareButtonTopLine.hidden = YES;
        }else{
            self.deleteButton.hidden = YES;
            self.compareButton.hidden = NO;
            self.compareButtonTopLine.hidden = NO;
            [self showbackButtonwithTitle:nil];
            [self showRightButton];
        }
        [self reloadData];
    }
    
}
-(void)showSelectAllButton{
    if (!self.selectAllButton) {
        self.selectAllButton = [[UIButton alloc]initNavigationButtonWithTitle:@"全选" color:BlackColor333333];
        [self.selectAllButton addTarget:self action:@selector(selectAllButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    [self showBarButton:NAV_RIGHT button:self.selectAllButton];
    
}
-(void)reloadData{
    
    @weakify(self);
    self.compareSelectedDictCount = self.compareSelectedDict.count;
    [RACObserve(self, editSelectedDictCount)subscribeNext:^(id x) {
        @strongify(self);
        if (self.editSelectedDictCount==0) {
            self.deleteButton.enabled = NO;
        }else{
            self.deleteButton.enabled = YES;
        }
    }];
    
    [RACObserve(self, compareSelectedDictCount)subscribeNext:^(id x) {
        @strongify(self);
        if (self.compareSelectedDictCount < 2) {
            self.compareButton.enabled = NO;
        }else{
            self.compareButton.enabled = YES;
        }
    }];

    self.compareAllDictCount = [CompareDict shareInstance].count;
    
    [RACObserve(self, compareAllDictCount)subscribeNext:^(id x) {
        @strongify(self);
        if (self.compareAllDictCount>=8) {
            [self.addCarButton setEnabled:NO];
        }else{
            [self.addCarButton setEnabled:YES];
        }
    }];
    
   
    if ([CompareDict shareInstance].count > 0) {
        self.tableViewButtonToSuperViewConstraint.priority = 500;
        [self.tableView dismissWithOutDataView];
    }else{
        
       self.tableViewButtonToSuperViewConstraint.priority = 800;
        [self.tableView showWithOutDataViewWithTitle:@"车型库还空着呢！添加车型对比吧"];
    }
    [self.tableView reloadData];
}
//添加右上角的按钮
-(void)showRightButton{
//    if (!self.addButton) {
//        self.addButton = [[UIButton alloc]initNavigationButton:[UIImage imageNamed:@"add.png"]];
//        [self.addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        
//    }
    
    if (!self.editButton) {
        self.editButton = [[UIButton alloc]initNavigationButtonWithTitle:@"编辑" color:BlackColor333333];
        [self.editButton addTarget:self action:@selector(editButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    
//    UIBarButtonItem*addItem = [[UIBarButtonItem alloc]initWithCustomView:self.addButton];
    UIBarButtonItem*editItem = [[UIBarButtonItem alloc]initWithCustomView:self.editButton];
   
    
    if([CompareDict shareInstance].count == 0){
        self.navigationItem.rightBarButtonItem =nil;
    }else{
        self.navigationItem.rightBarButtonItem = editItem;
    }
    
    
    
}
//添加
-(IBAction)addButtonClicked:(UIButton*)button{
    if([CompareDict shareInstance].count >= CompareMaxCount){
        [[DialogView sharedInstance]showDlg:self.view textOnly:@"最多只能添加8个车型"];
        return;
    }
    BrandViewController*VC = [[BrandViewController alloc]init];
    [VC selectedWithCarTypeCompareSelectedBlock:^(FindCarByGroupByCarTypeGetCarModel *model) {
        
            //         [[CompareDict shareInstance] setObject:obj forKey:obj.car_id];
            [[CompareDict shareInstance] setObject:model forKey:model.car_id];
       
            [self editCompareSlectedDictWithModel:model isDelete:NO];
            [model save];
            [self showRightButton];
            [self reloadData];
    } type:SelectCarTypeCompare selectedDict:nil];
       /// selectedDict 传空，以此区别进来的途径，是对比列表还是对比界面
    [self.rt_navigationController pushViewController:VC animated:YES];
}
-(void)editButtonClicked:(UIButton*)button{
    self.isEdit = YES;
}
//-(NSMutableArray*)compareSelectedArray{
//    if (!_compareSelectedArray) {
//        _compareSelectedArray = [NSMutableArray array];
//    }
//    return _compareSelectedArray;
//}
-(NSMutableDictionary*)compareSelectedDict{
    
    if (!_compareSelectedDict) {
         _compareSelectedDict = [NSMutableDictionary dictionary];
        NSArray*keyArray = [NSArray arrayWithContentsOfFile:[self compareSelectedDictPath]];
        [keyArray enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FindCarByGroupByCarTypeGetCarModel*model = [[FindCarByGroupByCarTypeGetCarModel Model] where:@{@"car_id":obj}];
            [_compareSelectedDict setObject:model forKey:obj];
            
        }];
    }
    return _compareSelectedDict;
    
}
-(NSString*)compareSelectedDictPath{
     NSString*path =[NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/%@compareSelectedDict",classNameFromClass([self class])];
    return path;
}
-(void)editCompareSlectedDictWithModel:(FindCarByGroupByCarTypeGetCarModel*)model isDelete:(BOOL)isDelete{
    if (!isDelete) {
        [self.compareSelectedDict setObject:model forKey:model.car_id];
       
    }else{
        [self.compareSelectedDict removeObjectForKey:model.car_id ];
        
    }
    self.compareSelectedDictCount = self.compareSelectedDict.count;
    [self.compareSelectedDict.allKeys writeToFile:[self compareSelectedDictPath] atomically:YES];
   
}

-(NSMutableDictionary*)editSelectedDict{
    if (!_editSelectedDict) {
        _editSelectedDict = [NSMutableDictionary dictionary];
    }
    return _editSelectedDict;
}

//-(NSMutableArray*)editSelectedArray{
//    if (!_editSelectedArray) {
//        _editSelectedArray = [NSMutableArray array];
//    }
//    return _editSelectedArray;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [CompareDict shareInstance].count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    NSDictionary*selectedDict;
    if (self.isEdit) {
        selectedDict = self.editSelectedDict;
    }else{
        selectedDict = self.compareSelectedDict;
    }
    CompareListTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(CompareListTableViewCell) forIndexPath:indexPath];
  FindCarByGroupByCarTypeGetCarModel*model =  [CompareDict shareInstance].allObjects[indexPath.row];
    [cell.nameButton setTitle:model.car_name forState:UIControlStateNormal];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
        if ([selectedDict objectForKey:model.car_id]) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }else{
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray*array =[CompareDict shareInstance].allObjects ;
    FindCarByGroupByCarTypeGetCarModel*model = array[indexPath.row];
    if (self.isEdit) {
        [self.editSelectedDict setObject:model forKey:model.car_id];
        self.editSelectedDictCount = self.editSelectedDict.count;
        if (self.editSelectedDictCount == [CompareDict shareInstance].count ) {
            self.selectAllButton.selected = YES;
            
            [self addjustButton:self.selectAllButton WithTitle:@"取消全选"];
            [self showSelectAllButton];
        }

    }else{
        [self editCompareSlectedDictWithModel:model isDelete:NO];
       
            }
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    FindCarByGroupByCarTypeGetCarModel*model = [CompareDict shareInstance].allObjects[indexPath.row];
    if (self.isEdit) {
        if (self.editSelectedDictCount == [CompareDict shareInstance].count ) {
            self.selectAllButton.selected = NO;
            [self addjustButton:self.selectAllButton WithTitle:@"全选"];
            [self showSelectAllButton];
        }
        [self.editSelectedDict removeObjectForKey:model.car_id ];
        self.editSelectedDictCount = self.editSelectedDict.count;
    }else{
       
       
        [self editCompareSlectedDictWithModel:model isDelete:YES];


    }
}
-(void)leftButtonTouch{
    if (self.isEdit) {
      
        [[CompareDict shareInstance].allObjects enumerateObjectsUsingBlock:^(FindCarByGroupByCarTypeGetCarModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
             [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO];
             [self.editSelectedDict removeObjectForKey:obj.car_id ];
        }];
        self.editSelectedDictCount = self.editSelectedDict.count;
        self.isEdit = NO;
    }else{
        [self.rt_navigationController popViewControllerAnimated:YES];
    }
}
///编辑时全选
-(void)selectAllButtonClicked:(UIButton*)button{
    button.selected = !button.selected;
    if (button.selected) {
        [self addjustButton:button WithTitle:@"取消全选"];
        [self showSelectAllButton];
        [[CompareDict shareInstance].allObjects enumerateObjectsUsingBlock:^(FindCarByGroupByCarTypeGetCarModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            [self.editSelectedDict setObject:obj    forKey:obj.car_id];
        }];

    }else{
        [self addjustButton:button WithTitle:@"全选"];
        [self showSelectAllButton];
        [[CompareDict shareInstance].allObjects enumerateObjectsUsingBlock:^(FindCarByGroupByCarTypeGetCarModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO];
           
        }];
        
        [self.editSelectedDict removeAllObjects];
    }
        self.editSelectedDictCount = self.editSelectedDict.count;
}
///比较
- (IBAction)compareClicked:(UIButton *)sender {
    
        ///对比
//        ParameterConfigViewController*vc = [[ParameterConfigViewController alloc]init];
//        vc.isCompare = YES;
//       
//        vc.carIds = self.compareSelectedDict.allKeys;
//        [self.rt_navigationController pushViewController:vc animated:YES];
    
    if (self.fatherType == ENUM_ViewController_TypeParamsCompare) {
        [self.rt_navigationController popViewControllerAnimated:YES];
        return;
    }
    
    NewCompareCarViewController *vc = [[NewCompareCarViewController alloc] init];
    vc.carIds = self.compareSelectedDict.allKeys;
    [self.rt_navigationController pushViewController:vc animated:YES];
 
    
}
- (IBAction)deleteButtonClicked:(UIButton *)sender {
   
        ///删除按钮
        [self.editSelectedDict.allValues enumerateObjectsUsingBlock:^(FindCarByGroupByCarTypeGetCarModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[CompareDict shareInstance] removreObjectForKey:obj.car_id];
            [self.editSelectedDict removeObjectForKey:obj.car_id];
            [self editCompareSlectedDictWithModel:obj isDelete:YES];
            
            [obj deleteSelf];
        }];
   
     self.editSelectedDictCount = self.editSelectedDict.count;
    self.compareSelectedDictCount = self.compareSelectedDict.count;
    if ([CompareDict shareInstance].count==0) {
        self.isEdit = NO;
        [self showRightButton];
    }else{
       [self showSelectAllButton];
    }
    
    [self reloadData];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    [self.compareSelectedDict removeAllObjects];
    NSArray*keyArray = [NSArray arrayWithContentsOfFile:[self compareSelectedDictPath]];
    [keyArray enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FindCarByGroupByCarTypeGetCarModel*model = [[FindCarByGroupByCarTypeGetCarModel Model] where:@{@"car_id":obj}];
        [self.compareSelectedDict setObject:model forKey:obj];
    }];
    
    [self reloadData];
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
