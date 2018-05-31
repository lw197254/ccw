//
//  AskForPriceViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2017/1/6.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "AskForPriceViewController.h"
#import "UITextField+placeholder.h"
#import "AskForPriceTableViewCell.h"
#import "CityViewController.h"
#import "AskForPriceViewModel.h"
#import "CustomTableViewCell.h"
#import "DialogView.h"

#import "UserInfo.h"

#import "AskPriceSuccessViewController.h"
#import "AskForPriceResultListModel.h"
#import "DisclaimerView.h"
#define maxSelectedCount 3
@interface AskForPriceViewController ()<UITableViewDelegate,UITableViewDataSource>
///展示经销商的tableview
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *mobileField;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (weak, nonatomic) IBOutlet UIButton *commitButton;
///经销商的选中
@property (strong, nonatomic)NSMutableArray *selectedArray;
@property (strong, nonatomic)AskForPriceViewModel *viewModel;
@property (copy, nonatomic)NSString *currentCarTypeName;
@property (copy, nonatomic)NSString *currentCarTypeId;
@property (copy, nonatomic)NSString *currentCarSeriesId;

@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UIView *lineView3;
@property (weak, nonatomic) IBOutlet UIView *lineView4;




@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineView1HeightConstaint;

//@property (strong, nonatomic)CarModel *currentCarModel;
///展示车型车系的tableview

@property (weak, nonatomic) IBOutlet UITableView *carTypeTableView;
///
@property (strong, nonatomic)NSArray *currentCarTypeDataArray;

@end

@implementation AskForPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self configUI];
    [self configData];
    // Do any additional setup after loading the view from its nib.
}


-(void)configData{
     @weakify(self);
    
    
    [[self.mobileField rac_textSignal] subscribeNext:^(NSString* x) {
        if (x.length>11) {
            NSString *info  = self.mobileField.text;
            self.mobileField.text = [info substringWithRange:NSMakeRange(0, 11)];
        }
    }];
    
    
    self.selectedArray = [NSMutableArray array];
    if ((self.carSerieasId||self.carTypeId)) {
        self.viewModel = [AskForPriceViewModel SceneModel];
        if(self.carTypeId){
           self.viewModel.askRequest.brand_son_type_id = self.carTypeId;
        }else{
            self.viewModel.askRequest.brand_type_id = self.carSerieasId;
        }
        if (self.cityId.isNotEmpty) {
            self.viewModel.askRequest.city_id = self.cityId;
            self.viewModel.askRequest.startRequest = YES;
        }
        if (!self.delearId) {
            [self showBarButton:NAV_RIGHT title:[AreaNewModel shareInstanceSelectedInstance].name fontColor:BlueColor447FF5];
        }
        
        
       
               [[RACObserve(self.viewModel, model)filter:^BOOL(id value) {
            @strongify(self);
            return self.viewModel.model.isNotEmpty;
        }]subscribeNext:^(id x) {
            @strongify(self);
            if (!self.carTypeName&&self.viewModel.model.cars.count > 0) {
                CarModel*model = [self.viewModel.model.cars firstObject];
                self.currentCarTypeId = model.brand_son_type_id;
                
                self.currentCarTypeName = model.brand_son_type_name;
                self.carTypeLabel.text = model.brand_son_type_name;
            }else{
                self.currentCarTypeId = self.carTypeId;
                self.currentCarTypeName = self.carTypeName;
            }
            self.currentCarSeriesId = self.carSerieasId;
            self.currentCarTypeDataArray = self.viewModel.model.cars;
            [self.selectedArray removeAllObjects];
            
            [self.tableView reloadData];
            [self.carTypeTableView reloadData];
        }];

    }
    if(self.delearId){
        self.viewModel = [AskForPriceViewModel SceneModel];
        self.viewModel.carSeriesRequest.dealerId = self.delearId;
       
        
        self.viewModel.carSeriesRequest.startRequest = YES;
        
        [[RACObserve(self.viewModel, carSeriesListModel)filter:^BOOL(id value) {
            @strongify(self);
            return self.viewModel.carSeriesListModel.isNotEmpty;
        }]subscribeNext:^(id x) {
            @strongify(self);
            if (!self.carTypeName&&self.viewModel.carSeriesListModel.data.count > 0&&((AskForPriceCarSeriesModel*)[self.viewModel.carSeriesListModel.data firstObject]).carlist.count > 0) {
                
                AskForPriceCarSeriesModel*carSeriesModel =    [self.viewModel.carSeriesListModel.data firstObject];
                AskForPriceCarTypeModel *model = [carSeriesModel.carlist firstObject];
                  self.currentCarTypeDataArray = self.viewModel.carSeriesListModel.data;
                self.currentCarTypeName = model.carname;
                self.currentCarSeriesId = carSeriesModel.typeid;
                self.currentCarTypeId = model.carid;
                self.carTypeLabel.text = model.carname;
            }else{
                 self.currentCarTypeDataArray = self.viewModel.carSeriesListModel.data;
            }
            
            [self.carTypeTableView reloadData];
        }];

    }
    
    
    
    [RACObserve(self.viewModel.commitRequest, state)subscribeNext:^(id x) {
        @strongify(self);
        if (self.viewModel.commitRequest.succeed) {
           
            AskPriceSuccessViewController *controllor =  [[AskPriceSuccessViewController alloc] init];
            controllor.model =[[AskForPriceResultListModel alloc]initWithDictionary:self.viewModel.commitRequest.output[@"data"] error:nil] ;
            [self addChildViewController:controllor];
            [self.view addSubview:controllor.view];
            [controllor.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
            if (self.viewModel.commitRequest.dealers.count > 0) {
                self.viewModel.messageRequest.mobile = self.viewModel.commitRequest.UserPhone;
                self.viewModel.messageRequest.dealers = self.viewModel.commitRequest.dealers;
                self.viewModel.messageRequest.carId = self.viewModel.commitRequest.dropCar;
                self.viewModel.messageRequest.startRequest = YES;
            }
            
             
        }
        
    }];
    [[RACSignal combineLatest:@[self.mobileField.rac_textSignal,self.nameField.rac_textSignal] reduce:^(NSString*mobile,NSString*name){
        return @(mobile.length==11&&name.isNotEmpty);
    }]subscribeNext:^(NSNumber* enabled) {
        @strongify(self);
        self.commitButton.enabled = [enabled boolValue];
        if (enabled.boolValue) {
            [self.commitButton setBackgroundColor:BlueColor447FF5];
        }else{
            [self.commitButton setBackgroundColor:[BlueColor447FF5 colorWithAlphaComponent:0.3]];
        }
        
    }];


}
-(void)configUI{
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.carTypeTableView setBackgroundColor:[UIColor whiteColor]];
    
    self.lineView1.backgroundColor = BlackColorE3E3E3;
    self.lineView2.backgroundColor = BlackColorE3E3E3;
    self.lineView3.backgroundColor = BlackColorE3E3E3;
    self.lineView1HeightConstaint.constant = lineHeight;
    
    [self showNavigationTitle:@"询底价"];
    if (!self.delearId) {
        if (self.cityName.isNotEmpty) {
            [self showBarButton:NAV_RIGHT title:self.cityName fontColor:BlueColor447FF5];
        }else{
          
                
                self.cityId = [AreaNewModel shareInstanceSelectedInstance].id;
                self.cityName = [AreaNewModel shareInstanceSelectedInstance].name;
                [self showBarButton:NAV_RIGHT title:self.cityName fontColor:BlueColor447FF5];
            
        }

    }
    
    self.carTypeLabel.text = self.carTypeName;
    self.nameField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    
    
    self.mobileField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
    self.mobileField.leftViewMode = UITextFieldViewModeAlways;
    self.nameField.leftViewMode = UITextFieldViewModeAlways;
    [self.nameField resetPlaceholderWithTextColor:BlackColorCCCCCC Font:FontOfSize(14)];
    [self.mobileField resetPlaceholderWithTextColor:BlackColorCCCCCC Font:FontOfSize(14)];
    [self.tableView registerNib:nibFromClass(AskForPriceTableViewCell) forCellReuseIdentifier:classNameFromClass(AskForPriceTableViewCell)];
    DisclaimerView *disclaimerView = [[DisclaimerView alloc] initWithFrame:CGRectMake(0, 0, kwidth, 30)];
    [disclaimerView setBackgroundColor:[UIColor whiteColor]];
    self.tableView.tableFooterView = disclaimerView;
    self.carTypeTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.carTypeTableView.hidden = YES;
    
    
    if ([[UserInfo getUserName]isNotEmpty]) {
        self.nameField.text = [UserInfo getUserName];
    }
    
    if ([[UserInfo getUserPhone]isNotEmpty]) {
        self.mobileField.text = [UserInfo getUserPhone];
    }
    
    self.cityLabel.text = [AreaNewModel shareInstanceSelectedInstance].name;
    
}
- (IBAction)cityClicked:(UIButton *)sender {
    CityViewController*vc = [[CityViewController alloc]init];
    vc.citySelectedBlock = ^(AreaNewModel *cityModel) {
        if (![self.cityId isEqual:cityModel.id]) {
            self.cityLabel.text = cityModel.name;
        }
    };
    self.carTypeTableView.hidden  = YES;
    
    [self.rt_navigationController pushViewController:vc animated:YES];

}
- (IBAction)carTypeClicked:(UIButton *)sender {
    self.carTypeTableView.hidden = NO;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.tableView) {
        if (self.delearId) {
            return 0;
        }
        return (self.viewModel.model.dealer_list.count==0?0:2);
    }else{
        return (self.currentCarTypeDataArray.count==0?0:1);
        
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        if (section==0) {
            return 0;
        }else{
            return self.viewModel.model.dealer_list.count;
        }
    }else{
        return self.currentCarTypeDataArray.count;
    }
    
}
- (IBAction)conmmitClicked:(UIButton *)sender {
   
    
    self.viewModel.commitRequest.UserName = [self.nameField.text stringByTrimmingLeadingWhitespaceAndNewlineCharacters];
     self.viewModel.commitRequest.UserPhone = [self.mobileField.text stringByTrimmingLeadingWhitespaceAndNewlineCharacters];
   
    if(!self.currentCarTypeId){
        self.currentCarTypeId = self.carTypeId;
    }
    if(!self.currentCarSeriesId){
        self.currentCarSeriesId = self.carSerieasId;
    }
    self.viewModel.commitRequest.dropCar = self.currentCarTypeId;
    self.viewModel.commitRequest.dropType = self.currentCarSeriesId;
    self.viewModel.commitRequest.clue_id = [ClueIdObject getClueId];
    
     self.viewModel.commitRequest.dropCity = [AreaNewModel shareInstanceSelectedInstance].id;
    if (self.delearId.isNotEmpty) {
        self.viewModel.commitRequest.dealers =@[self.delearId];
    }else{
         self.viewModel.commitRequest.dealers =self.selectedArray;
    }
   
    
    if ([self.mobileField.text isNotEmpty]&&
        self.mobileField.text.length==11 && [[self.mobileField.text substringToIndex:1] isEqualToString:@"1"]) {
        
        [UserInfo setUserName:self.viewModel.commitRequest.UserName];
        [UserInfo setUserPhone:self.viewModel.commitRequest.UserPhone];
        
        
        self.viewModel.commitRequest.startRequest = YES;
    }else{
        [[DialogView sharedInstance]showDlg:self.view textOnly:@"手机号码不正确"];
    }
    

}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        if (section != 0) {
             return [NSString stringWithFormat:@"您最多可选择%d家本地经销商",maxSelectedCount];
        }
       
    }
return nil;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView == self.tableView) {
        if (section==0) {
            return 10;
        }
        return 30;
    }else{
        return 0.0000001;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  
        return 0.000001;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        return 100;
    }else{
        return 44;
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        AskForPriceTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(AskForPriceTableViewCell) forIndexPath:indexPath];
        DealerModel*model = self.viewModel.model.dealer_list[indexPath.row];
        cell.storeNameLabel.text = model.name;
        cell.priceLabel.text = [model.price stringByAppendingString:@"万"];
        cell.addressLabel.text = model.address;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        CustomTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ];
        if (!cell) {
            cell = [[CustomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.textLabel.textColor = BlackColor333333;
            cell.textLabel.font = FontOfSize(15);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if(self.currentCarTypeDataArray == self.viewModel.model.cars){
            CarModel*model = self.viewModel.model.cars[indexPath.row];
            cell.textLabel.text = model.brand_son_type_name;
 
        }else if (self.currentCarTypeDataArray == self.viewModel.carSeriesListModel.data){
            AskForPriceCarSeriesModel*model = self.currentCarTypeDataArray[indexPath.row];
            cell.textLabel.text = model.typename;
        }else{
           
            AskForPriceCarTypeModel*mo = self.currentCarTypeDataArray[indexPath.row];
            cell.textLabel.text = mo.carname;
        }
        
        
        
        return cell;
    }
   
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = FontOfSize(12);
    header.contentView.backgroundColor = [UIColor whiteColor];
    header.textLabel.textColor = BlackColor333333;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView == tableView) {
        if (self.selectedArray.count >= maxSelectedCount) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }else{
            DealerModel*model = self.viewModel.model.dealer_list[indexPath.row];
            
            [self.selectedArray addObject:model.id];
        }
    }else{
        if(self.currentCarTypeDataArray == self.viewModel.model.cars){
           
            self.carTypeTableView.hidden = YES;
            CarModel*model = self.viewModel.model.cars[indexPath.row];
            
            self.currentCarTypeId = model.brand_son_type_id;
            self.currentCarTypeName = model.brand_son_type_name;
            self.carTypeLabel.text = model.brand_son_type_name;
            
        }else if (self.currentCarTypeDataArray == self.viewModel.carSeriesListModel.data){
            AskForPriceCarSeriesModel*model = self.currentCarTypeDataArray[indexPath.row];
            
             [tableView deselectRowAtIndexPath:indexPath animated:YES];
            self.currentCarTypeDataArray = model.carlist;
            [self.carTypeTableView reloadData];
           
            
        }else{
            
            AskForPriceCarTypeModel*model = self.currentCarTypeDataArray[indexPath.row];
            self.carTypeTableView.hidden = YES;
            self.currentCarSeriesId = model.typeid;
            self.currentCarTypeId = model.carid;
            self.currentCarTypeName = model.carname;
            self.carTypeLabel.text = model.carname;
            self.currentCarTypeDataArray = self.viewModel.carSeriesListModel.data;
            
             [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self.carTypeTableView reloadData];
        }

       
        
    }
    
    
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        DealerModel*model = self.viewModel.model.dealer_list[indexPath.row];
        
        [self.selectedArray removeObject:model.id];
    }
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)rightButtonTouch{
    CityViewController*vc = [[CityViewController alloc]init];
    vc.citySelectedBlock = ^(AreaNewModel *cityModel) {
        if (![self.cityId isEqual:cityModel.id]) {
            self.cityId = cityModel.id;
            self.viewModel.askRequest.city_id= self.cityId;
            self.viewModel.askRequest.startRequest = YES;
        }
    };
    self.carTypeTableView.hidden  = YES;

    [self.rt_navigationController pushViewController:vc animated:YES];
}

-(void)leftButtonTouch{
    if (self.carTypeTableView.hidden == NO) {
        if (self.currentCarTypeDataArray != self.viewModel.carSeriesListModel.data&&self.currentCarTypeDataArray != self.viewModel.model.cars){
           
            self.currentCarTypeDataArray = self.viewModel.carSeriesListModel.data;
            [self.carTypeTableView reloadData];
            
            
        }
        self.carTypeTableView.hidden = YES;
    }else{
        [super leftButtonTouch];
    }
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
