//
//  BrandViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.

#import "BrandMutableSelectViewController.h"
#import "BrandViewModel.h"
#import "HTHorizontalSelectionList.h"
#import "BrandMutableTableViewCell.h"



#import "CustomNavigationBar.h"
#import "UITableView+CustomTableViewIndexView.h"


@interface BrandMutableSelectViewController()<UITableViewDelegate,UITableViewDataSource,HTHorizontalSelectionListDelegate,HTHorizontalSelectionListDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *customNavigationView;

@property (weak, nonatomic) IBOutlet HTHorizontalSelectionList *conditionHorizontalView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conditionContentViewHeightConstraint;
@property(nonatomic,strong)NSArray*bannerArray;
@property(nonatomic,strong)NSArray*titleArray;

@property(nonatomic,strong)BrandViewModel*viewModel;
@property (weak, nonatomic) IBOutlet UIButton *confirmSelectButton;
@property(nonatomic,strong)NSMutableArray*selectedArray;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property(nonatomic,copy)BrandMulableSelectedBlock brandSelectedBlock;
@property(nonatomic,copy)NSString* sectionKey;


#define hotBrandSection 0

@end


@implementation BrandMutableSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
   
//    [self showBarButton:NAV_RIGHT title:@"重置" fontColor:BlackColor666666];
   
    [self configUI];
    self.viewModel = [BrandViewModel SceneModel];
    self.viewModel.request.startRequest = YES;
    
    [[RACObserve(self.viewModel, model)filter:^BOOL(id value) {
        return self.viewModel.model.isNotEmpty;
    }]subscribeNext:^(id x) {
       
        [self.tableView reloadData];
        [self.tableView reloadViewWithArray:self.viewModel.model.sectionIndexTitleArray select:nil];
        
    }];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)configUI{
    self.lineView.backgroundColor = BlackColorE3E3E3;
    [self.tableView registerNib:nibFromClass(BrandMutableTableViewCell) forCellReuseIdentifier:classNameFromClass(BrandMutableTableViewCell)];
    self.tableView.customIndexViewTextColor = BlueColor447FF5;
    [self.tableView reloadViewWithArray:self.viewModel.model.sectionIndexTitleArray select:nil];
    self.conditionHorizontalView.backgroundColor = BlackColorF8F8F8;
    self.conditionHorizontalView.selectionIndicatorStyle = HTHorizontalSelectionIndicatorStyleNone;
    self.conditionHorizontalView.delegate = self;
    self.conditionHorizontalView.dataSource = self;
    self.conditionHorizontalView.leftSpace = 10;
    self.conditionHorizontalView.seperateSpace = 10;
    self.conditionHorizontalView.topSpace = (44-28)/2;
    self.conditionHorizontalView.bottomSpace = (44-28)/2;
    self.conditionHorizontalView.bottomTrimColor = [UIColor clearColor];
}
-(NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList{
    return self.selectedArray.count;
}
-(UIView*)selectionList:(HTHorizontalSelectionList *)selectionList viewForItemWithIndex:(NSInteger)index{
    ConditionModel*model = self.selectedArray[index];
    
    return [BrandMutableSelectViewController createBrandButtonWithTitle:model.value];
}
-(void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index{
    ConditionModel*model = self.selectedArray[index];
    [self selectedArrayAddObject:nil deleteModel:model];
    
    [self.conditionHorizontalView reloadData];
    [self.tableView reloadData];
    
}

///头部banner配置数据
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.model.sectionIndexTitleArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    FindCarBrandSectionListModel*model = self.viewModel.model.list[section];
    
    return model.array.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    
    if (section == self.viewModel.model.sectionIndexTitleArray.count-1) {
        return 55;
    }
    return 0.000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    CustomTableViewHeaderSectionView*view = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:classNameFromClass(CustomTableViewHeaderSectionView)];
//    [view setTitle:@"条件选车" subTitle:@"共11个" section:section SelectedBlock:^(NSInteger section) {
//        if (section==0) {
//            ConditionSelectCarViewController*condition = [[ConditionSelectCarViewController alloc]init];
//            [self.navigationController pushViewController:condition animated:YES];
//        }
//    }];
//    return view;
//
//}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = FontOfSize(14);
    header.textLabel.textColor = BlackColor333333;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.viewModel.model.sectionHeaderTitleArray[section];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
           BrandMutableTableViewCell*cell =[tableView dequeueReusableCellWithIdentifier:classNameFromClass(BrandMutableTableViewCell) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        FindCarBrandSectionListModel*sectionModel = self.viewModel.model.list[indexPath.section];
        BrandModel*model = sectionModel.array[indexPath.row];
        [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"默认汽车品牌"]];
        cell.titleLabel.text =model.name;
    ConditionModel*mod = [self.selectedArray find:^BOOL(ConditionModel *obj) {
        if ([obj.index isEqual:model.id]) {
            return YES;
            
        }else{
            return NO;
        }
    }];
    if (!mod) {
        
         [tableView deselectRowAtIndexPath:indexPath animated:NO];
        cell.selected = NO;
       
    }else{
       
       
         [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
         cell.selected = YES;
    }

        return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FindCarBrandSectionListModel*sectionModel = self.viewModel.model.list[indexPath.section];
    BrandModel*model = sectionModel.array[indexPath.row];
   
    ConditionModel*mod = [self.selectedArray find:^BOOL(ConditionModel *obj) {
        if ([obj.index isEqual:model.id]) {
            return YES;
            
        }else{
            return NO;
        }
    }];
    if (!mod) {
       
      
        ConditionModel*condition = [[ConditionModel alloc]init];
        condition.value = model.name;
        condition.index = model.id;
        condition.sectionKey = self.sectionKey;
        [self selectedArrayAddObject:condition deleteModel:nil];
        
        [self.conditionHorizontalView reloadData];
        [self.confirmSelectButton setTitle:[NSString stringWithFormat:@"确认选择(%ld)",self.selectedArray.count] forState:UIControlStateNormal];
        
    }
   
    
   
   
}
-(void)updatePlaceholderLabel{
    if (self.selectedArray.count==0) {
        self.conditionContentViewHeightConstraint.constant = 0;
//        self.placeholderLabel.hidden = NO;
    }else{
         self.conditionContentViewHeightConstraint.constant = 45;
//        self.placeholderLabel.hidden = YES;
    }
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    FindCarBrandSectionListModel*sectionModel = self.viewModel.model.list[indexPath.section];
    BrandModel*model = sectionModel.array[indexPath.row];
   __block ConditionModel*mod;
   __block NSInteger findIdx = 0;
    [self.selectedArray enumerateObjectsUsingBlock:^(ConditionModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.index isEqual:model.id]) {
            mod = obj;
            findIdx = idx;
            *stop = YES;
        }

    }];
       if (mod) {
          
           [self selectedArrayAddObject:nil deleteModel:mod];
           
        [self.conditionHorizontalView reloadData];
        
          }
    
   

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
-(void)rightButtonTouch{
    [self.viewModel.model.list enumerateObjectsUsingBlock:^(FindCarBrandSectionListModel * obj, NSUInteger section, BOOL * _Nonnull stop) {
        [obj.array enumerateObjectsUsingBlock:^(BrandModel * _Nonnull obj, NSUInteger row, BOOL * _Nonnull stop) {
            [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] animated:NO];
        }];
    }];
    
    [self.selectedArray removeAllObjects];
    [self.conditionHorizontalView reloadData];
    [self updatePlaceholderLabel];
    [self.confirmSelectButton setTitle:@"确认选择" forState:UIControlStateNormal];

}
- (IBAction)confirmSelectButtonClicked:(UIButton *)sender {
      if(self.brandSelectedBlock){
        self.brandSelectedBlock(self.selectedArray);
    }

    [self backButtonClicked:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updatePlaceholderLabel];
    if (self.selectedArray.count==0) {
        
        [self.confirmSelectButton setTitle:[NSString stringWithFormat:@"确认选择"] forState:UIControlStateNormal];
        
        
    }else{
        
        [self.confirmSelectButton setTitle:[NSString stringWithFormat:@"确认选择(%ld)",self.selectedArray.count] forState:UIControlStateNormal];
    }
    
    if (IOS_11_OR_LATER) {
        
    }else{
        [self.customNavigationView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(StatusHeight);
        }];
    }
    
    [self.tableView reloadData];
    [self.conditionHorizontalView reloadData];
}
///刚进界面时同步使用
-(void)resetWithSelectedArray:(NSArray<ConditionModel *> *)selectedArray selectedFinishedBlock:(BrandMulableSelectedBlock)block sectionKey:(NSString *)sectionKey{
    self.sectionKey = sectionKey;
    [self.selectedArray removeAllObjects];
    [self.selectedArray addObjectsFromArray:selectedArray];
    if (self.brandSelectedBlock !=block) {
        self.brandSelectedBlock = block;
    }
    
}

-(void)selectedArrayAddObject:(ConditionModel*)model deleteModel:(ConditionModel*)deleteModel{
    if (model) {
        __block BOOL findObj = NO;
        [self.selectedArray enumerateObjectsUsingBlock:^(ConditionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.sectionKey isEqual:model.sectionKey]&&(!model.rowKey||[obj.rowKey isEqual:model.rowKey])&&[obj.index isEqual:model.index]) {
                findObj =YES;
                *stop = YES;
            }
        }];
        if (!findObj) {
            [self.selectedArray insertObject:model atIndex:0 ];
        }
        
    }
    if (deleteModel) {
        [self.selectedArray enumerateObjectsUsingBlock:^(ConditionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.sectionKey isEqual:deleteModel.sectionKey]&&(!deleteModel.rowKey||[obj.rowKey isEqual:deleteModel.rowKey])&&[obj.index isEqual:deleteModel.index]) {
                [self.selectedArray removeObject:obj];
                *stop = YES;
            }
        }];
        
    }
    [self.conditionHorizontalView reloadData];
    
    [self updatePlaceholderLabel];
    if (self.selectedArray.count==0) {
        
        [self.confirmSelectButton setTitle:[NSString stringWithFormat:@"确认选择"] forState:UIControlStateNormal];
        
        
    }else{
        
        [self.confirmSelectButton setTitle:[NSString stringWithFormat:@"确认选择(%ld)",self.selectedArray.count] forState:UIControlStateNormal];
    }

}
//-(void)updateSelectedContentViewWithTitle:(NSString*)title isDelete:(BOOL)isDelete{
//    
//    if (isDelete) {
//        [self.selectedContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if ([title isEqual:[obj titleForState:UIControlStateNormal]]) {
//                if (idx==0) {
//                    if (self.selectedContentView.subviews.count >idx+1) {
//                        UIView*rightView = self.selectedContentView.subviews[idx+1];
//                       
//                        [rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                            make.left.equalTo(self.selectedContentView).with.offset(15);
//                            make.height.mas_equalTo(28);
//                            make.centerY.equalTo(self.selectedContentView);
//                            if (self.selectedContentView.subviews.count > idx+2) {
//                               
//                            }else{
//                                make.right.equalTo(self.selectedContentView).with.offset(-15);
//                            }
//                            
//                        }];
//                    }
//                    
//                    [obj removeFromSuperview];
//                    *stop = YES;
//                }else if (idx==self.selectedContentView.subviews.count-1){
//                    UIView*leftView = self.selectedContentView.subviews[idx-1];
//                   
//                    [leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                        make.right.equalTo(self.selectedContentView).with.offset(-15);
//                        
//                        make.height.mas_equalTo(28);
//                        make.centerY.equalTo(self.selectedContentView);
//                        if (idx >= 2) {
//                            UIView*sencondView = self.selectedContentView.subviews[idx-2];
//                            make.left.equalTo(sencondView.mas_right).with.offset(10);
//                           
//                        }else{
//                            make.left.equalTo(self.selectedContentView).with.offset(15);
//                        }
//                        
//                    }];
//                    
//                    [obj removeFromSuperview];
//                    *stop = YES;
//                    
//                }else{
//                    UIView*leftView = self.selectedContentView.subviews[idx-1];
//                    
//                    UIView*rightView = self.selectedContentView.subviews[idx+1];
//                   
//                    [rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                        make.left.equalTo(leftView.mas_right).with.offset(10);
//                        make.height.mas_equalTo(28);
//                        make.centerY.equalTo(self.selectedContentView);
//                        if (self.selectedContentView.subviews.count > idx+2) {
//                            
//                            
//                        }else{
//                           
//                                make.right.equalTo(self.selectedContentView).with.offset(-15);
//                           
//                            
//                        }
//
//                    }];
//                   
//
//                    [obj removeFromSuperview];
//                    *stop = YES;
//                    
//                }
//            }
//        }];
//    }else{
//        ///添加按钮
//        UIButton*button = [self createBrandButtonWithTitle:title];
//        [self.selectedContentView insertSubview:button atIndex:0];
//        if (self.selectedContentView.subviews.count >1) {
//            UIView*rightView = self.selectedContentView.subviews[1];
//            
//            
//            [rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(button.mas_right).with.offset(10);
//                make.height.mas_equalTo(28);
//                make.centerY.equalTo(self.selectedContentView);
//                if (self.selectedContentView.subviews.count >2) {
////                    UIView*secondView = self.selectedContentView.subviews[2];
////                    make.right.equalTo(secondView.mas_left).with.offset(-10);
//                }else{
//                    make.right.equalTo(self.selectedContentView).with.offset(-15);
//                }
//                
//                
//            }];
//        }else{
//            [button mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(self.selectedContentView).with.offset(-15);
//            }];
//        }
//        [button mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.selectedContentView).with.offset(15);
//            make.centerY.equalTo(self.selectedContentView);
//        }];
//    }
//     [self updatePlaceholderLabel];
//}
///返回
- (IBAction)backButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

+(UIButton*)createBrandButtonWithTitle:(NSString*)title{
  UIButton*btn =  [Tool createButtonWithImage:nil target:nil action:nil tag:0];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:BlackColor666666 forState:UIControlStateNormal];
    btn.titleLabel.font = FontOfSize(14);
    [btn setBackgroundColor: [UIColor whiteColor]];
    UIImageView*imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"close.png"]];
    [btn addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btn).with.offset(-5);
        make.centerY.equalTo(btn);
    }];
    btn.contentMode = UIViewContentModeLeft;
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 13+5+5);
//    [btn exchangeImageAndTitleWithSpace:0];
//    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(28);
//    }];
    return btn;
}
-(NSMutableArray*)selectedArray{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}
//-(NSMutableArray*)orignalSelectedArray{
//    if (!_orignalSelectedArray) {
//        _orignalSelectedArray = [NSMutableArray array];
//    }
//    return _orignalSelectedArray;
//}
@end

