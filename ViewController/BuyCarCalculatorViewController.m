//
//  BuyCarCalculatorViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2017/3/7.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "BuyCarCalculatorViewController.h"
#import "BuyCarCalculatorListModel.h"
#import "BuyCarCalculatorTableViewCell.h"
#import "BuyCarCalculatorInsuranceTableViewCell.h"
#import "BrandViewController.h"
#import "BuyCarCalculatorDataModel.h"
#import "UIScrollView+EndEdit.h"
#import "CustomTableViewHeaderSectionView.h"
#import "BuyCarCalculatorRightListViewController.h"
#import "HTHorizontalSelectionList.h"

//自己获取车辆信息
#import "CarTypeDetailViewModel.h"

#define quanKuanHeaderHeight  105 
#define daiKuanHeaderHeight  155 
///因参数太多，英语不好，所以以下参数全用拼音全拼表示
@interface BuyCarCalculatorViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,HTHorizontalSelectionListDelegate,HTHorizontalSelectionListDataSource>
@property (weak, nonatomic) IBOutlet HTHorizontalSelectionList *horizontalSelectionList;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *daiKuanImageView;
@property (weak, nonatomic) IBOutlet UIImageView *quanKuanImageView;
@property (weak, nonatomic) IBOutlet UIView *shouFuYueGongLiXiView;
@property (weak, nonatomic) IBOutlet UILabel *zongJiaTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *zongJiaLabel;
@property (weak, nonatomic) IBOutlet UILabel *yueGongTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *shouFuLabel;
@property (weak, nonatomic) IBOutlet UILabel *yueGongLabel;
@property (weak, nonatomic) IBOutlet UILabel *liXiLabel;






@property(nonatomic,strong)BuyCarCalculatorListModel*daiKuanModel;
@property(nonatomic,strong)BuyCarCalculatorListModel*quanKuanModel;
@property(nonatomic,strong)BuyCarCalculatorListModel*jsonModel;



@property (strong, nonatomic) CarTypeDetailViewModel *viewModel;

@end

@implementation BuyCarCalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNavigationTitle:@"购车计算器"];
    [self showBarButton:NAV_RIGHT title:@"重置" fontColor:BlueColor447FF5];
    self.horizontalSelectionList.delegate = self;
    self.horizontalSelectionList.dataSource = self;
    self.horizontalSelectionList.maxShowCount = 2;
    self.horizontalSelectionList.minShowCount = 2;
    self.horizontalSelectionList.selectionIndicatorColor = BlueColor447FF5;
    self.dataModel = [[BuyCarCalculatorDataModel alloc]init];
    [self.dataModel selectAllBaoxian];
    
   //   self.dataModel.cheShangRenYuanShu
    
    
    if (![self.paiLiangString isNotEmpty]) {
        self.viewModel.request.chexingId = self.cheXingId;
        
        @weakify(self)
        [[RACObserve(self.viewModel, model)
         filter:^BOOL(id value) {
             return self.viewModel.model.isNotEmpty;
         }]subscribeNext:^(id x) {
             if (x) {
                 self_weak_.seatNumber = self.viewModel.model.zws;
                 self_weak_.paiLiangString = self.viewModel.model.engine_capacity;
                 [self_weak_ updateDataModel];
                 [self_weak_ updateHeaderView];
                 [self_weak_.tableView reloadData];
             }
         }];
        
        self.viewModel.request.startRequest = YES;
    }else{
        [self updateDataModel];
    }
    

     [self initData];
    

    // Do any additional setup after loading the view from its nib.
}

-(void)initData{
    NSString*path =  [[NSBundle mainBundle] pathForResource:@"BuyCarCalculatorLoan" ofType:@"json"];
    
    NSData*data = [[NSMutableData alloc]initWithContentsOfFile: path];   NSDictionary*dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    self.daiKuanModel = [[BuyCarCalculatorListModel alloc]initWithDictionary:dict error:nil];
    
    NSString*path1 =  [[NSBundle mainBundle] pathForResource:@"BuyCarCalculator" ofType:@"json"];
    
    NSData*data1 = [[NSMutableData alloc]initWithContentsOfFile: path1];   NSDictionary*dict1 = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
    
    self.quanKuanModel = [[BuyCarCalculatorListModel alloc]initWithDictionary:dict1 error:nil];
    self.jsonModel = self.quanKuanModel;
    [self.tableView registerNib:nibFromClass(BuyCarCalculatorInsuranceTableViewCell) forCellReuseIdentifier:classNameFromClass(BuyCarCalculatorInsuranceTableViewCell)];
    [self.tableView registerNib:nibFromClass(BuyCarCalculatorTableViewCell) forCellReuseIdentifier:classNameFromClass(BuyCarCalculatorTableViewCell)];
    [self.tableView registerClass:[CustomTableViewHeaderSectionView class] forHeaderFooterViewReuseIdentifier:classNameFromClass(CustomTableViewHeaderSectionView)];
    
    
    self.headerView.frame = CGRectMake(0, 0, kwidth, quanKuanHeaderHeight);
    self.tableView.tableHeaderView = self.headerView;
    [self updateHeaderView];
    if (self.buyType== BuyTypeDaiKuan) {
        
        [self.horizontalSelectionList setSelectedButtonIndex:1];
        [self selectionList:self.horizontalSelectionList didSelectButtonWithIndex:1];
    }

}
-(void)updateDataModel{
    self.dataModel.luoCheJiaGe = self.price;
    self.dataModel.cheXingString = self.cheXingString;
    if([self.seatNumber integerValue]< 6){
        self.dataModel.jiaoQiangXianZuoWei = JiaoQiangXianZuoWei1_5;
    }else{
        self.dataModel.jiaoQiangXianZuoWei = JiaoQiangXianZuoWei6;
    }
    self.dataModel.cheShangRenYuanShuNumber = [self.seatNumber integerValue];
//    paiLiangQuJian1L = 0, ///
//    paiLiangQuJian1_1_6L ,
//    paiLiangQuJian1_6_2_0L,
//    paiLiangQuJian2_0_2_5L,
//    paiLiangQuJian2_5_3_0L,
//    paiLiangQuJian3_0_4_0L,
//    paiLiangQuJian4_0L
    if ([self.paiLiangString floatValue]<=1.0) {
        self.dataModel.paiLiangQuJian = paiLiangQuJian1L;
    }else if ([self.paiLiangString floatValue]<=1.6){
        self.dataModel.paiLiangQuJian = paiLiangQuJian1_1_6L;
    }else if ([self.paiLiangString floatValue]<=2.0){
        self.dataModel.paiLiangQuJian = paiLiangQuJian1_6_2_0L;
    }else if ([self.paiLiangString floatValue]<=2.5){
        self.dataModel.paiLiangQuJian = paiLiangQuJian2_0_2_5L;
    }else if ([self.paiLiangString floatValue]<=3.0){
        self.dataModel.paiLiangQuJian = paiLiangQuJian2_5_3_0L;
    }else if ([self.paiLiangString floatValue]<=4.0){
        self.dataModel.paiLiangQuJian = paiLiangQuJian3_0_4_0L;
    }else{
         self.dataModel.paiLiangQuJian = paiLiangQuJian4_0L;
    }
    
}

-(NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList{
    return 2;
}
-(NSString*)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index{
    return @[@"全款计算器",@"贷款计算器"][index];
}
-(void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index{
    if (index==0) {
        ///全款
        self.dataModel.isDaiKuan = NO;
        self.headerView.frame = CGRectMake(0, 0, kwidth, quanKuanHeaderHeight);
        self.daiKuanImageView.hidden = YES;
        self.quanKuanImageView.hidden = NO;
        self.shouFuYueGongLiXiView.hidden = YES;
        self.tableView.tableHeaderView = self.headerView;
        self.jsonModel = self.quanKuanModel;
    }else{
        self.dataModel.isDaiKuan = YES;
        self.daiKuanImageView.hidden = NO;
        self.shouFuYueGongLiXiView.hidden = NO;
        self.quanKuanImageView.hidden = YES;
        self.headerView.frame = CGRectMake(0, 0, kwidth, daiKuanHeaderHeight);
        
        self.tableView.tableHeaderView = self.headerView;
        self.jsonModel = self.daiKuanModel;
        
    }
    [self updateUI];
}
-(void)updateUI{
    [self updateHeaderView];
    [self.tableView reloadData];
}
-(void)updateHeaderView{
    if (self.dataModel.isDaiKuan) {
        self.zongJiaTitleLabel.text = @"贷款总价";
    }else{
        self.zongJiaTitleLabel.text = @"全款总价";
    }
    self.zongJiaLabel.text =[[Tool changeNumberFormat:self.dataModel.zongJia] stringByAppendingString:@"元"];
    self.shouFuLabel.text = [Tool changeNumberFormat:self.dataModel.shouFu];
    
    self.yueGongTitleLabel.text = [NSString stringWithFormat:@"月供(%@)",self.dataModel.huanKuanQiShuString];
    self.yueGongLabel.text = [Tool changeNumberFormat:self.dataModel.yueGong];
    self.liXiLabel.text = [Tool changeNumberFormat:self.dataModel.liXi];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.jsonModel.list.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    BuyCarCalculatorSectionModel*model = self.jsonModel.list[section];
    if (model.title.isNotEmpty) {
        return 28;
    }else{
        return 0.000001;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     BuyCarCalculatorSectionModel*model = self.jsonModel.list[section];
    return model.list.count;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CustomTableViewHeaderSectionView*view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:classNameFromClass(CustomTableViewHeaderSectionView)];
    view.topLine.hidden = YES;
    view.middleLine.hidden = YES;
    view.bottomLine.hidden = YES;
    BuyCarCalculatorSectionModel*sectionModel;
   
    sectionModel = self.jsonModel.list[section];
   
    
    view.titleLabel.font = FontOfSize(13);
    view.titleLabel.textColor = BlackColor333333;
    view.subTitleLabel.font = FontOfSize(13);
    view.subTitleLabel.textColor = BlueColor447FF5;
    view.subTitleLabel.text = [self strWithString: sectionModel.subTitle];
    view.titleLabel.text = sectionModel.title;
    return view;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     BuyCarCalculatorSectionModel*sectionModel = self.jsonModel.list[indexPath.section];
    BuyCarCalculatorModel*model = sectionModel.list[indexPath.row];
    ///保险
    if ([sectionModel.id isEqualToString:@"2"]) {
        BuyCarCalculatorInsuranceTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(BuyCarCalculatorInsuranceTableViewCell) forIndexPath:indexPath];
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = model.title;
        if (model.subTitle.isNotEmpty) {
            
            cell.subTitleLabel.text = [self strWithString: model.subTitle];
        }else{
            cell.subTitleLabel.text = @"";
        }
        
        cell.selectButton.tag = indexPath.row;
        [cell.selectButton addTarget:self action:@selector(baoXianClicked:) forControlEvents:UIControlEventTouchUpInside];
        if ([self strWithString: [model.value stringByAppendingString:@"Selected"]]) {
            BOOL selected = [[self strWithString: [model.value stringByAppendingString:@"Selected"]] boolValue];
            cell.selectButton.selected = selected;
        }
     
        cell.valueLabel.text =[self strWithString: model.value];
        cell.rightImageView.image = [UIImage imageNamed:model.rightImageName];
        return cell;
    }else{
        BuyCarCalculatorTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(BuyCarCalculatorTableViewCell) forIndexPath:indexPath];
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = model.title;
        if (model.subTitle.isNotEmpty) {
            
            cell.subTitleLabel.text = [self strWithString: model.subTitle];
        }else{
            cell.subTitleLabel.text = @"";
        }
        cell.valueField.text =[self strWithString: model.value];
        cell.valueField.delegate = self;
        if (indexPath.section==0&&indexPath.row==1) {
            cell.valueField.userInteractionEnabled = YES;
        }else{
            cell.valueField.userInteractionEnabled = NO;
        }
       
        
        
        cell.rightImageView.image = [UIImage imageNamed:model.rightImageName];

        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BuyCarCalculatorSectionModel*sectionModel = self.jsonModel.list[indexPath.section];
    if (indexPath.section==0&&indexPath.row==0) {
        BrandViewController*vc = [[BrandViewController alloc]init];
        vc.carSeriesType = CarSeriesTypeDelear;
        [vc selectedWithCarTypeCompareSelectedBlock:^(FindCarByGroupByCarTypeGetCarModel *model) {
            self.cheXingString = model.car_name;
            
            if (model.factory_price.isNotEmpty) {
                
                self.price  =[model.factory_price floatValue]*10000;
            }else{
                self.price = 0;
            }
            self.seatNumber = model.seatnum;
            self.paiLiangString = model.engine_capacity;
            [self updateDataModel];
            [self updateUI];
        } type:SelectCarTypeSingleSelect selectedDict:nil];
        [self.rt_navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section==0&&indexPath.row==1){
        BuyCarCalculatorTableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [cell.valueField becomeFirstResponder];
    }else{
       
        BuyCarCalculatorModel*model = sectionModel.list[indexPath.row];
        if ([self strWithString: [model.value stringByAppendingString:@"Selected"]]) {
            BuyCarCalculatorInsuranceTableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
            BOOL selected = [[self strWithString: [model.value stringByAppendingString:@"Selected"]] boolValue];
            if (!selected) {
                [self baoXianClicked:cell.selectButton];
            }else{
                if (model.rightImageName.isNotEmpty) {
                    
                    NSArray*array = [self.dataModel valueForKey: [model.value stringByAppendingString:@"LieBiao"]];
                    NSString* item   = [self strWithString:model.value];
                     NSString* subTitleItem   = [self strWithString:model.subTitle];
                    NSString*select;
                    if (array) {
                       
                        select= item;
                    }else{
                         array = [self.dataModel valueForKey: [model.subTitle stringByAppendingString:@"LieBiao"]];
                        select =  subTitleItem ;
                    }
                    BuyCarCalculatorRightListViewController*vc = [[BuyCarCalculatorRightListViewController alloc]init];
                   
                    [vc selectWithArray:array selectedItem:select selectedBlock:^(NSInteger index, NSString *selectedItem) {
                         [self.dataModel setValue:[NSNumber numberWithInteger:index] forKey: model.subTitle ];
                        [self updateUI];
                    }];
                    [self.rt_navigationController pushViewController:vc animated:YES];
                }
            }
        }else{
            if (model.rightImageName.isNotEmpty) {
                NSArray*array = [self.dataModel valueForKey: [model.value stringByAppendingString:@"LieBiao"]];
                NSString* item   = [self strWithString:model.value];
                NSString* subTitleItem   = [self strWithString:model.subTitle];
                NSString*select;
                if (array) {
                    
                    select= item;
                }else{
                    array = [self.dataModel valueForKey: [model.subTitle stringByAppendingString:@"LieBiao"]];
                    select =  subTitleItem ;
                }
                if ([model.title isEqualToString:@"还款年限"]) {
                    select = [NSString stringWithFormat:@"%@(%@)",item,subTitleItem];
                }
                if ([model.title isEqualToString:@"车上人员责任险"]) {
                    
                }
                
                BuyCarCalculatorRightListViewController*vc = [[BuyCarCalculatorRightListViewController alloc]init];
                
                [vc selectWithArray:array selectedItem:select selectedBlock:^(NSInteger index, NSString *selectedItem) {
                    [self.dataModel setValue:[NSNumber numberWithInteger:index] forKey: model.subTitle ];
                    [self updateUI];
                }];
                [self.rt_navigationController pushViewController:vc animated:YES];
            

            
            }
        }
    
    }


}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.dataModel.luoCheJiaGe = [textField.text integerValue];
    [self updateUI];
}


-(NSString*)strWithString:(NSString*)str{
    NSString*value = [self.dataModel valueForKey:[str stringByAppendingString:@"String"]];
    if(!value.isNotEmpty){
        id aa = [self.dataModel valueForKey:str];
        if ([aa isKindOfClass:[NSNumber class]]) {
            NSInteger i = [aa integerValue];
            value = [Tool changeNumberFormat:i];
        }else{
            value = aa;
        }
    }
    return value;
}
-(void)baoXianClicked:(UIButton*)button{
    button.selected = !button.selected;
     BuyCarCalculatorSectionModel*sectionModel = [self.jsonModel.list lastObject];
    if ([sectionModel.id isEqualToString:@"2"]) {
         BuyCarCalculatorModel*model = sectionModel.list[button.tag];
        
       [ self.dataModel setValue:[NSNumber numberWithBool:button.selected] forKey:[model.value stringByAppendingString:@"Selected"]];
        [self updateUI];
    }
    
}
-(void)rightButtonTouch{
    
    [self.dataModel resetAll];
    [self updateUI];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 懒加载

-(CarTypeDetailViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [CarTypeDetailViewModel SceneModel];
    }
    return _viewModel;
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
