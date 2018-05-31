//
//  UserInfoViewController.m
//  12123
//
//  Created by 刘伟 on 2016/10/13.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "UserInfoViewController.h"

#import "UIImagePickerController+RACSignalSupport.h"
#import "UploadHeaderImage.h"
#import "UserInfoViewModel.h"
#import "PickerView.h"
#import "NickNameViewController.h"
#import "ModifyMobileViewController.h"
#import "CityNewViewModel.h"
@interface UserInfoViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>



@property(nonatomic,strong)UserInfoViewModel *viewModel;
@property(nonatomic,strong)CityNewViewModel *cityViewModel;
//@property(nonatomic,assign)BOOL ischangeimage;
@property(nonatomic,strong)PickerView * areaPickView;
@property(nonatomic,strong)NSArray * provinceArray;
@property(nonatomic,strong)NSArray * cityArray;
@property(nonatomic,strong)NSArray * areaArray;
@property(nonatomic,assign)BOOL isfirstsee;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
 
@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self showNavigationTitle:@"个人中心"];
  
    self.viewModel = [UserInfoViewModel SceneModel];
//    self.viewModel.userInfoRequest.uid = [UserModel shareInstance].uid;
//    self.viewModel.userInfoRequest.startRequest = YES;
    [self updateUI];

//    //不修改headimg的情况下 我的默认头像.png点击为空
//    self.ischangeimage = NO;
    
    // Do any additional setup after loading the view from its nib.
    //添加手势功能 头像
    UITapGestureRecognizer* headTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleHeadImageTap:)];
    [self.headimage addGestureRecognizer:headTap];
    
    //添加手势功能 用户名
    UITapGestureRecognizer* nicknameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleNickTap:)];
    [self.nickname addGestureRecognizer:nicknameTap];
    
    
    //添加手势功能 性别
    UITapGestureRecognizer* sexTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSexTap:)];
    [self.sex addGestureRecognizer:sexTap];
    
    //添加手势功能 电话
    UITapGestureRecognizer* phonenameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePhoneTap:)];
    [self.phone addGestureRecognizer:phonenameTap];
    

    
    //添加手势功能 地区
    UITapGestureRecognizer* areaTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAreaTap:)];
    [_area addGestureRecognizer:areaTap];
    [self addRAC];
    [self configAreaPickerView];
    
  }

//初始化数据

-(void)updateUI{
    UserModel*model = [UserModel shareInstance];
    
    
    if (model.loginType==LoginTypeCheChengWang) {
         self.phonelabel.text = model.mobile;
        self.phone.hidden = NO;
    }else{
        self.phone.hidden = YES;
    }
   
    if (model.nickname.isNotEmpty) {
        self.nicknamelabel.text = model.nickname;
    }
    NSString*area = @"";
    if (model.provincename.isNotEmpty) {
        area = model.provincename;
    }
    if (model.cityname.isNotEmpty) {
        if (![model.provincename isEqualToString:model.cityname]) {
            area = [area stringByAppendingString:model.cityname];
        }
        
    }
    if (model.areaname.isNotEmpty) {
        area = [area stringByAppendingString:model.areaname];
    }
    
    self.arealabel.text = area;
//    
//    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].head]];
    UIImage*image = self.headImageView.image;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].head] placeholderImage:image];
    if ([UserModel shareInstance].sex ==GenderWomen) {
         self.sexlabel.text = @"女";
    }else{
         self.sexlabel.text = @"男";
    }
    if ([UserModel shareInstance].mobile.isNotEmpty) {
        self.phonelabel.text =[UserModel shareInstance].mobile;
    }
    
}


-(void)addRAC{
    @weakify(self);
       [[RACObserve(self.viewModel.request,state)
      filter:^BOOL(id value) {
          @strongify(self);
          return self.viewModel.request.succeed;
      }]subscribeNext:^(id x) {
          @strongify(self);
          [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"修改成功"];
          [[UserModel shareInstance]mergeFromDictionary:self.viewModel.request.output[@"data"] useKeyMapping:YES];
          [self updateUI];
          //          [self.navigationController popViewControllerAnimated:YES];
          //[[DialogUtil sharedInstance]showDlg:self.view textOnly:[@"成功"]];
          //         self.dataArray = self.viewModel.model.data;
          //        [self.tableView reloadData];
          
      }];

    
    [[RACObserve(self.viewModel.uploadHeadImageRequest,state)
      filter:^BOOL(id value) {
          @strongify(self);
          return self.viewModel.uploadHeadImageRequest.succeed||self.viewModel.uploadHeadImageRequest.failed;
      }]subscribeNext:^(id x) {
          @strongify(self);
         
         
          if (self.viewModel.uploadHeadImageRequest.succeed) {
              self.viewModel.request.head = [self.viewModel.uploadHeadImageRequest.output valueForKeyPath:@"data.imgUrl"];
              self.viewModel.request.startRequest = YES;
          }else{
              [[DialogView sharedInstance]showDlg:self.view textOnly:@"图片上传失败"];
          }
         
          
      }];
    
    if (!self.cityViewModel) {
        self.cityViewModel =[CityNewViewModel SceneModel];
       
        [[RACObserve(self.cityViewModel, model)filter:^BOOL(id value) {
            @strongify(self);
            return self.cityViewModel.model.isNotEmpty;
        }]subscribeNext:^(id x) {
            @strongify(self);
            [self resetProvinceArray];
            AreaNewModel*provinceModel = [self.provinceArray firstObject];
            [self resetCityArrayWithProvinceId:provinceModel.id];
            
            AreaNewModel*cityModel = [self.cityArray firstObject];
            [self resetAreaArrayWithCityId:cityModel.id];
            [self areaPickViewReloadAllComponents];
            
            
            
            
        }];
        if (self.cityViewModel.model&&self.cityViewModel.model.info.count >0) {
            self.cityViewModel.request.areav = self.cityViewModel.model.areav+1;
            self.cityViewModel.request.needLoadingView = NO;
            self.cityViewModel.request.startRequest = YES;
        }else{
            self.cityViewModel.request.areav = 0;
            self.cityViewModel.request.needLoadingView = YES;
            self.cityViewModel.request.startRequest = YES;
        }
        
    }
    


   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleHeadImageTap:(UITapGestureRecognizer *)sender
{
    [UploadHeaderImage shareInstanceWithSuccessBlock:^(UIImage *image, NSString *imageDataString) {
        self.viewModel.uploadHeadImageRequest.headdata = imageDataString;
        self.viewModel.uploadHeadImageRequest.startRequest = YES;
       
        
    }];

}

-(void)handleNickTap:(UITapGestureRecognizer *)sender
{
    NickNameViewController*vc = [[NickNameViewController alloc]init];
    vc.hideRightButton = YES;
    vc.titleString = @"修改昵称";
    vc.nickNameModifySuccessBlock = ^(NSString *nickName) {
        self.nicknamelabel.text = nickName;
       // self.changeUserModel.nickname = nickName;
    };
    [self presentViewController:vc animated:YES completion:nil];
    //[self showAlertView:@"修改昵称" MyMessage:@"输入昵称" toLabel:_nicknamelabel];
}

-(void)handlePhoneTap:(UITapGestureRecognizer *)sender

{
    ModifyMobileViewController*vc = [[ModifyMobileViewController alloc]init];
    [self.rt_navigationController pushViewController:vc animated:YES];
  //[self showAlertView:@"修改手机号" MyMessage:@"输入手机号" toLabel:_phonelabel];
}

-(void)handleSexTap:(UITapGestureRecognizer *)sender

{
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"选择性别" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *leftAction = [UIAlertAction actionWithTitle:@"男" style: UIAlertActionStyleDefault handler:^(UIAlertAction * action){
       
        if ([UserModel shareInstance].sex != GenderMan) {
            self.viewModel.request.sex = [NSString stringWithFormat:@"%ld",GenderMan];
             self.sexlabel.text = @"男";
            self.viewModel.request.startRequest = YES;
        }
       
    }];
    
    UIAlertAction *rightAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
       
        if ([UserModel shareInstance].sex != GenderWomen) {
             self.sexlabel.text = @"女";
            self.viewModel.request.sex = [NSString stringWithFormat:@"%ld",GenderWomen];
            self.viewModel.request.startRequest = YES;
        }
       
    }];
    
    [alertCtrl addAction:leftAction];
    [alertCtrl addAction:rightAction];
    
    
    
    
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

-(void)handleAreaTap:(UITapGestureRecognizer *)sender

{
//    ProvinceViewController*city =[ProvinceViewController shareInstance];
//    city.selectedCityName = _arealabel.text;
//    [self.navigationController pushViewController:city animated:YES];
//    [city finishedSelected:^(CityModel *model){
//        _arealabel.text = model.all_name;
//    }];
      [self.areaPickView show];
    [self areaPickViewReloadAllComponents];
    
}
///城市重置所有数组
-(void)areaPickViewReloadAllComponents{
    
   
    [self resetProvinceArray];
    NSString*province = [UserModel shareInstance].province;
    NSString*city =[UserModel shareInstance].city;
    NSString*area = [UserModel shareInstance].area;
   
  __block NSInteger  provinceRow = 0;
    if (province.isNotEmpty&&[province integerValue]!=0) {
       
        [self.provinceArray enumerateObjectsUsingBlock:^(AreaNewModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.id isEqualToString:province]) {
                provinceRow = idx;
                *stop = YES;
            }
        }];
        [self resetCityArrayWithProvinceId:province];
    }else{
        AreaNewModel*provinceModel = [self.provinceArray firstObject];
        province = provinceModel.id;
        [self resetCityArrayWithProvinceId:province];
        
    }
    
 
    
  
    __block NSInteger  cityRow = 0;
    
    if (city.isNotEmpty&&[city integerValue]!=0) {
        [self.cityArray enumerateObjectsUsingBlock:^(AreaNewModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.id isEqualToString:city]) {
                cityRow = idx;
                *stop = YES;
            }
        }];
        [self resetAreaArrayWithCityId:city];

    }else{
        AreaNewModel*cityModel = [self.cityArray firstObject];
        city = cityModel.id;
        [self resetAreaArrayWithCityId:city];
    }
    __block NSInteger  areaRow = 0;
    if (area.isNotEmpty&&[area integerValue]!=0) {
        [self.areaArray enumerateObjectsUsingBlock:^(AreaNewModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.id isEqualToString:area]) {
                areaRow = idx;
                *stop = YES;
            }
        }];
    }
    [self.areaPickView.pickerView reloadAllComponents];
    if (self.provinceArray.count > 0) {
         [self.areaPickView.pickerView selectRow:provinceRow inComponent:0 animated:NO];
    }
    if (self.cityArray.count > 0) {
        [self.areaPickView.pickerView selectRow:cityRow inComponent:1 animated:NO];
    }
    if (self.areaArray.count > 0) {
        [self.areaPickView.pickerView selectRow:areaRow inComponent:2 animated:NO];
    }
   
   
}
-(void)showAlertView:(NSString *)title MyMessage:(NSString *)mymessage toLabel:(UILabel *)target{
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:title message:mymessage preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *leftAction = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        UITextField* textfield = [alertCtrl textFields][0];
        [target setText:textfield.text];
       
    }];
    
    
    UIAlertAction *rightAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    [alertCtrl addAction:leftAction];
    
    [alertCtrl addAction:rightAction];
    
    [alertCtrl addTextFieldWithConfigurationHandler:nil];
    
    [self presentViewController:alertCtrl animated:YES completion:nil];
    
    
     UITextField* textfield = [alertCtrl textFields][0];
    //初始化数值 位置不可变
    if([target.text isNotEmpty]){
        [textfield setText:target.text];
    }
    
    //nickname初始化长度和输入控制
  
    _isfirstsee =YES;
    if([target isEqual:_nicknamelabel]){
        textfield.placeholder = @"用户的昵称长度为1-15位";
        
        [[RACSignal combineLatest:@[textfield.rac_textSignal] reduce:^(NSString*text){
            if (textfield.text.length ==0) {
                [leftAction setEnabled:NO];
            }else{
                
            }
            return @(textfield.text.length!=0);
        }]subscribeNext:^(NSNumber* x) {
            if ([x boolValue]) {
                if (textfield.text.length >=15) {
                    textfield.text = [textfield.text substringToIndex:15];
                }
                [leftAction setEnabled:YES];
            }
            
        }];
    }
    
}
-(void)configAreaPickerView{
    if(!self.areaPickView){
        self.areaPickView = [PickerView pickerViewWithConfirmBlock:^{
         NSInteger provinceIndex =   [self.areaPickView.pickerView selectedRowInComponent:0];
             NSInteger cityIndex =   [self.areaPickView.pickerView selectedRowInComponent:1];
             NSInteger areaIndex =   [self.areaPickView.pickerView selectedRowInComponent:2];
            if (self.provinceArray.count >provinceIndex&&self.cityArray.count >cityIndex&&self.areaArray.count >areaIndex) {
                AreaNewModel*province = self.provinceArray[provinceIndex];
                AreaNewModel*city =self.cityArray[cityIndex];
                AreaNewModel*area = self.areaArray[areaIndex];
                
                
                self.arealabel.text = [NSString stringWithFormat:@"%@%@%@",province.name,city.name,area.name];
                if ([province.id isEqualToString:[UserModel shareInstance].province]&&[city.id isEqualToString:[UserModel shareInstance].city]&&[area.id isEqualToString:[UserModel shareInstance].area]) {
                    
                }else{
                    self.viewModel.request.province = province.id;
                    self.viewModel.request.city = city.id;
                    self.viewModel.request.area = area.id;
                    self.viewModel.request.startRequest = YES;
                }

            }
            
        }];
        self.areaPickView.pickerView.delegate = self;
        self.areaPickView.pickerView.dataSource = self;
    }

    
    [self.view addSubview:self.areaPickView];
    self.areaPickView.titleLabel.text = @"";
    [self.areaPickView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    self.areaPickView.hidden = YES;
    self.areaPickView.pickerView.dataSource = self;
    self.areaPickView.pickerView.delegate =self;
    
    

    
    
}
///设置城市数组
-(void)resetProvinceArray{
    /// "type":"1"//1-省 2-市 3-区
    NSPredicate*provincePredicate =[NSPredicate predicateWithFormat:@"type MATCHES %@", @"1"];
    self.provinceArray = [self.cityViewModel.model.info filteredArrayUsingPredicate:provincePredicate];
}

///设置城市数组
-(void)resetCityArrayWithProvinceId:(NSString*)provinceId{
    if (provinceId.isNotEmpty) {
        NSPredicate*cityPredicate =[NSPredicate predicateWithFormat:@"type MATCHES %@ AND parent_id MATCHES %@", @"2",provinceId];
        self.cityArray = [self.cityViewModel.model.info filteredArrayUsingPredicate:cityPredicate];
    }else{
         self.cityArray= nil;
    }
    
}
///设置区数组
-(void)resetAreaArrayWithCityId:(NSString*)cityId{
    if (cityId.isNotEmpty) {
        NSPredicate*cityPredicate =[NSPredicate predicateWithFormat:@"type MATCHES %@ AND parent_id MATCHES %@", @"3",cityId];
        self.areaArray = [self.cityViewModel.model.info filteredArrayUsingPredicate:cityPredicate];
    }else{
        self.areaArray= nil;
    }
    
}
#pragma mark pickerview的代理方法
-(NSAttributedString*)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString*string;
    AreaNewModel*model;
    if (component==0) {
        model = self.provinceArray[row];
    }else if (component==1){
        model= self.cityArray[row];
    }else{
        model = self.areaArray[row];
    }
    
   
    string = model.name;
    
    
    if (string.length > 0) {
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
        UIFont *font = FontOfSize(17);
        [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
        return attrString;
    }else{
        return nil;
    }
   
}
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* recycleLable;
    if (view==nil) {
        recycleLable = [Tool createLabelWhichTextFontIsTwelf];
        recycleLable.textColor = BlackColor333333;
        recycleLable.font = FontOfSize(17);
    }else{
        recycleLable = (UILabel*)view;
    }
    
    recycleLable.textAlignment = NSTextAlignmentCenter;
    
    NSString*string;
    if (pickerView==self.areaPickView.pickerView) {
      
        AreaNewModel*model;
        if (component==0) {
            model = self.provinceArray[row];
        }else if (component==1){
            model= self.cityArray[row];
        }else{
            model = self.areaArray[row];
        }
        
        
        string = model.name;

    }
    
    recycleLable.text =string;
    return recycleLable;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
   
    if (component==0) {
       return  self.provinceArray.count;
    }else if (component==1){
       return  self.cityArray.count;
    }else{
         return  self.areaArray.count;
    }
    
    
   
}
//-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    NSString*string = self.birthdayArray[component][row];
//    return string;
//}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component==0) {
        AreaNewModel*model = self.provinceArray[row];
        [self resetCityArrayWithProvinceId:model.id];
         [pickerView reloadComponent:component+1];
       
        if (self.cityArray.count > 0) {
            AreaNewModel*city = self.cityArray[0];
            [pickerView selectRow:0 inComponent:component+1 animated:YES];
            [self resetAreaArrayWithCityId:city.id];
             [pickerView reloadComponent:component+2];
            if (self.areaArray.count >0) {
                 [pickerView selectRow:0 inComponent:component+2 animated:YES];
            }
           
           
        }
       
        
      
    }else if (component==1){
        AreaNewModel*model = self.cityArray[row];
      
        
        [self resetAreaArrayWithCityId:model.id];
        [pickerView reloadComponent:component+1];
        if (self.areaArray.count >0) {
            [pickerView selectRow:0 inComponent:component+1 animated:YES];
        }

      
    }
    if (component <2) {
        [pickerView reloadComponent:component+1];
    }
    
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 3;
    
    
}

#pragma mark pickerview的代理方法结束
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateUI];
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
