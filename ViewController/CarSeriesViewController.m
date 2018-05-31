//
//  BrandViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2016/12/27.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "CarSeriesViewController.h"
#import "CarSeriesTableViewCell.h"
#import "BrandIntroduceViewController.h"
#import "CarSeriesViewModel.h"
#import "CarDeptViewController.h"

@interface CarSeriesViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *selectedBrandLabel;
@property (weak, nonatomic) IBOutlet UIImageView *brandImageView;
@property(nonatomic,strong)CarSeriesViewModel*viewModel;
///对比时用的
@property(nonatomic,strong)NSMutableDictionary*selectedDict;
@end

@implementation CarSeriesViewController
- (IBAction)panGesture:(UIPanGestureRecognizer *)sender {
    CGPoint point =   [sender translationInView:self.view];
    if (point.x <0) {
        
        return;
    }
    ///上一次手势的位置
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:{
          
            self.view.transform =  CGAffineTransformMakeTranslation( point.x, 0);
            break;
        }
        case  UIGestureRecognizerStateChanged:{
             self.view.transform =CGAffineTransformMakeTranslation( point.x, 0);
            break;
        }
        case  UIGestureRecognizerStateCancelled:{
            break;
        }
        case  UIGestureRecognizerStateEnded:{
            if (point.x >self.view.frame.size.width/4) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.view.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0);
                }completion:^(BOOL finished) {
                    [self.view removeFromSuperview];
                    [self removeFromParentViewController];
                }];
            }else {
                [UIView animateWithDuration:0.25 animations:^{
                    self.view.transform = CGAffineTransformMakeTranslation(0, 0);
                }];
            }
            break;
        
        }
            
    };
    
   
   
    
    
    
}

-(void)refreshViewController{
     [self updateUI];
    self.viewModel.request.pinpaiId = self.brandModel.id;
    self.viewModel.factoryRequest.facId = self.factoryId;
    [self.tableView.mj_header beginRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNavigationTitle:@"选择车系"];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.directionalLockEnabled = YES;
    [self.tableView registerNib:nibFromClass(CarSeriesTableViewCell) forCellReuseIdentifier:classNameFromClass(CarSeriesTableViewCell)];
    self.viewModel = [CarSeriesViewModel SceneModel];
    
    @weakify(self);
    if (self.factoryId) {
        self.tableView.mj_header = [CustomRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.viewModel.factoryRequest.startRequest = YES;
        }];
        [[RACObserve(self.viewModel, factoryModel) filter:^BOOL(id value) {
            @strongify(self);
            return self.viewModel.factoryModel.isNotEmpty;
        }]subscribeNext:^(id x) {
            @strongify(self);
            [self.tableView.mj_header endRefreshing];
            if (!self.brandModel) {
                self.brandModel = [[BrandModel alloc]init];
                
            }
            self.brandModel.name= self.viewModel.factoryModel.brand.brandname;
            self.brandModel.id= self.viewModel.factoryModel.brand.brandid;
            self.brandModel.url= self.viewModel.factoryModel.brand.picurl;
            [self updateUI];

            if(self.viewModel.factoryModel.list.count > 0){
                [self.tableView dismissWithOutDataView];
                [self.tableView reloadData];
            }else{
                
                [self.tableView showWithOutDataViewWithTitle:@"暂无"];
            }
        }];
        [[RACObserve(self.viewModel.factoryRequest, state) filter:^BOOL(id value) {
            @strongify(self);
            return self.viewModel.factoryRequest.failed;
        }]subscribeNext:^(id x) {
            @strongify(self);
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
            [self.tableView showNetLost];
        }];

    }else{
        self.tableView.mj_header = [CustomRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.viewModel.request.startRequest = YES;
        }];
        [[RACObserve(self.viewModel, model) filter:^BOOL(id value) {
            @strongify(self);
            return self.viewModel.model.isNotEmpty;
        }]subscribeNext:^(id x) {
            @strongify(self);
            [self.tableView.mj_header endRefreshing];
            if(self.viewModel.model.data.count > 0){
                [self.tableView dismissWithOutDataView];
                [self.tableView reloadData];
            }else{
               [self.tableView showWithOutDataViewWithTitle:@"暂无"];
            }
        }];
        [[RACObserve(self.viewModel.request, state) filter:^BOOL(id value) {
            @strongify(self);
            return self.viewModel.request.failed;
        }]subscribeNext:^(id x) {
            @strongify(self);
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
            [self.tableView showNetLost];
        }];

    }
    [self refreshViewController];
    // Do any additional setup after loading the view from its nib.
}
-(void)updateUI{
    [self.brandImageView sd_setImageWithURL:[NSURL URLWithString:self.brandModel.url] placeholderImage:[UIImage imageNamed:@"默认图片80_60"]];
    self.selectedBrandLabel.text = self.brandModel.name;
}
- (IBAction)brandIntroduceClicked:(UIButton *)sender {
    BrandIntroduceViewController*brand = [[BrandIntroduceViewController alloc]init];
    brand.brandName = self.brandModel.name;
    brand.brandId = self.brandModel.id;
    [self.rt_navigationController pushViewController:brand animated:YES];
}
//-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
//    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
//    header.textLabel.font = FontOfSize13;
//}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.factoryId) {
        return self.viewModel.factoryModel.list.count>0?1:0;
    }
    return self.viewModel.model.data.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.factoryId) {
        return self.viewModel.factoryModel.list.count;
    }
    CarSeriesSectionModel*model = self.viewModel.model.data[section];
    return model.list.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CarSeriesTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(CarSeriesTableViewCell) forIndexPath:indexPath];
    if (self.factoryId) {
        CarSeriesFactoryModel*model = self.viewModel.factoryModel.list[indexPath.row];
        cell.titleLabel.text = model.typename;
        cell.subTitleLabel.text = model.price;
        
        [cell.headImageView setImageWithURL:[NSURL URLWithString:model.picurl] placeholderImage:[UIImage imageNamed:@"默认图片80_60.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }else{
        CarSeriesSectionModel*sectionModel = self.viewModel.model.data[indexPath.section];
        CarSeriesModel*model = sectionModel.list[indexPath.row];
        cell.titleLabel.text = model.name;
        cell.subTitleLabel.text = model.guildPrice;
        [cell.headImageView setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"默认图片80_60.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    
    
    return cell;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(self.factoryId){
        return self.carSeriesName;
    }
     CarSeriesSectionModel*sectionModel = self.viewModel.model.data[section];
    return sectionModel.name;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = FontOfSize(12);
    header.contentView.backgroundColor = BlackColorF1F1F1;
    header.textLabel.textColor = BlackColor333333;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.factoryId) {
        CarSeriesFactoryModel*model = self.viewModel.factoryModel.list[indexPath.row];
        CarDeptViewController *vc = [[CarDeptViewController alloc]init];
        vc.picture  = model.picurl;
        vc.chexiid = model.typeid;
        [URLNavigation pushViewController:vc animated:YES];
    }else{
        CarSeriesSectionModel*sectionModel = self.viewModel.model.data[indexPath.section];
        CarSeriesModel*model = sectionModel.list[indexPath.row];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if(self.carSeriesType == CarSeriesTypeCompare||self.carSeriesType == CarSeriesTypeSingleSelect){
            SelectCarTypeViewController*vc = [[SelectCarTypeViewController alloc]init];
            vc.carSeriesName = model.name;
            if (self.carSeriesType == CarSeriesTypeCompare) {
                [vc selectedWithCarTypeCompareSelectedBlock:self.carTypeCompareSelectedBlock type:SelectCarTypeCompare typeId:[model.id integerValue] selectedDict:self.selectedDict];
            }else{
                [vc selectedWithCarTypeCompareSelectedBlock:self.carTypeCompareSelectedBlock type:SelectCarTypeSingleSelect typeId:[model.id integerValue] selectedDict:self.selectedDict];
            }
            
            [self.rt_navigationController pushViewController:vc animated:YES];
            
        }else if(self.carSeriesType == CarSeriesTypeNormal){
            CarDeptViewController *vc = [[CarDeptViewController alloc]init];
            vc.picture  = model.picUrl;
            vc.chexiid = model.id;
            [URLNavigation pushViewController:vc animated:YES];
        }else{
            
            ///经销商
            
            UIViewController*vc  =    self.rt_navigationController.rt_viewControllers[self.rt_navigationController.rt_viewControllers.count-1-2];
            if (self.carSeriesSelectedBlock) {
                self.carSeriesSelectedBlock(model);
            }
            [self.rt_navigationController popToViewController:vc animated:YES];
        }

    }
    
    
  
}
-(void)selectedWithCarTypeCompareSelectedBlock:(CarTypeCompareSelectedBlock)block carSeriesType:(CarSeriesType)type selectedDict:(NSMutableDictionary*)selectedDict{
    
    self.carSeriesType = type;
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
