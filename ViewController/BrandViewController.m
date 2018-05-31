//
//  BrandViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.

#import "BrandViewController.h"
#import "BrandViewModel.h"
#import "DialogView.h"
#import "BrandTableViewCell.h"




#import "UITableView+CustomTableViewIndexView.h"


@interface BrandViewController()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSArray*bannerArray;
@property(nonatomic,strong)NSArray*titleArray;
@property (weak, nonatomic) IBOutlet UIButton *allBrandButton;
@property(nonatomic,strong)BrandViewModel*viewModel;
@property(nonatomic,strong)NSMutableDictionary*selectedDict;

#define hotBrandSection 0

@end


@implementation BrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    [self showNavigationTitle:@"品牌"];
    
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
- (IBAction)allBrandClicked:(UIButton *)sender {
   
    
    if(self.carSeriesType == CarSeriesTypeNormal){
        BrandModel*model = [[BrandModel alloc]init];
        model.name = @"全部品牌";
        model.id = @"";
        if (self.brandSelectedBlock) {
            self.brandSelectedBlock(model);
        }
        [self.rt_navigationController popViewControllerAnimated:YES];
      
    }else if(self.carSeriesType == CarSeriesTypeDelear){
        if (self.brandSelectedBlock) {
            self.brandSelectedBlock(nil);
        }
        [self.rt_navigationController popViewControllerAnimated:YES];
    }else{
        [[DialogView sharedInstance]showDlg:self.view textOnly:@"不可选择全部品牌"];
    }
}
-(void)configUI{
   
    [self.tableView registerNib:nibFromClass(BrandTableViewCell) forCellReuseIdentifier:classNameFromClass(BrandTableViewCell)];
    self.tableView.customIndexViewTextColor = BlueColor447FF5;
    [self.tableView reloadViewWithArray:self.viewModel.model.sectionIndexTitleArray select:nil];
    
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
//            [self.rt_navigationController pushViewController:condition animated:YES];
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
           BrandTableViewCell*cell =[tableView dequeueReusableCellWithIdentifier:classNameFromClass(BrandTableViewCell) forIndexPath:indexPath];
        FindCarBrandSectionListModel*sectionModel = self.viewModel.model.list[indexPath.section];
        BrandModel*model = sectionModel.array[indexPath.row];
        [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"默认汽车品牌"]];
        cell.titleLabel.text =model.name;
        return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FindCarBrandSectionListModel*sectionModel = self.viewModel.model.list[indexPath.section];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BrandModel*model = sectionModel.array[indexPath.row];
    if (self.carSeriesType == CarSeriesTypeCompare) {
        CarSeriesViewController*vc = [[CarSeriesViewController alloc]init];
        vc.brandModel = model;
        [vc selectedWithCarTypeCompareSelectedBlock:self.carTypeCompareSelectedBlock carSeriesType:CarSeriesTypeCompare selectedDict:self.selectedDict];
        [self.rt_navigationController pushViewController:vc animated:YES];
    }else if(self.carSeriesType == CarSeriesTypeSingleSelect){
        CarSeriesViewController*vc = [[CarSeriesViewController alloc]init];
        vc.brandModel = model;
        [vc selectedWithCarTypeCompareSelectedBlock:self.carTypeCompareSelectedBlock carSeriesType:self.carSeriesType selectedDict:self.selectedDict];
        [self.rt_navigationController pushViewController:vc animated:YES];
        
    
    }else if(self.carSeriesType == CarSeriesTypeNormal){
        if (self.brandSelectedBlock) {
            self.brandSelectedBlock(model);
        }
        [self.rt_navigationController popViewControllerAnimated:YES];

    }else{
        CarSeriesViewController*vc = [[CarSeriesViewController alloc]init];
        vc.brandModel = model;
        vc.carSeriesType = self.carSeriesType;
        vc.carSeriesSelectedBlock = self.carSeriesSelectedBlock;
        [self.rt_navigationController pushViewController:vc animated:YES];
    }
    
}
-(void)selectedWithCarTypeCompareSelectedBlock:(CarTypeCompareSelectedBlock)block type:(SelectCarType)type selectedDict:(NSMutableDictionary*)selectedDict{
    if (SelectCarTypeSingleSelect == type) {
        self.carSeriesType = CarSeriesTypeSingleSelect;
    }else{
        self.carSeriesType = CarSeriesTypeCompare;

    }
    
    if (self.carTypeCompareSelectedBlock!=block) {
        self.carTypeCompareSelectedBlock = block;
    }
    self.selectedDict = selectedDict;
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

