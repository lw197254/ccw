//
//  ColorPickViewController.m
//  chechengwang
//
//  Created by 严琪 on 17/2/20.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ColorPickViewController.h"
#import "ColorTableViewHeaderFooterView.h"
#import "ColorTableViewCell.h"
#import "ColorDoubleTableViewCell.h"

#import "CarColorTypeModel.h"

@interface ColorPickViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSArray *colorlistName;

@end

@implementation ColorPickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"选择颜色"];
    
    self.colorlistName = @[@"外观颜色",@"内饰颜色"];
    
    [self initTableView];
    [self initData];
    
    [self showbackButtonwithTitle:@""];
}


-(void)initTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    //头部图片 全部
    [self.tableView registerNib:[UINib nibWithNibName:@"ColorTableViewCell" bundle:nil] forCellReuseIdentifier:@"ColorTableViewCell"];
    //车外
    [self.tableView registerNib:[UINib nibWithNibName:@"ColorTableViewCell" bundle:nil] forCellReuseIdentifier:@"ColorTableView"];
    //车内
    [self.tableView registerNib:[UINib nibWithNibName:@"ColorDoubleTableViewCell" bundle:nil] forCellReuseIdentifier:@"ColorDoubleTableViewCell"];
}

-(void)initData{
    if (self.viewModel.model.isNotEmpty) {

    }else{
        self.viewModel.request.startRequest = YES;
        @weakify(self);
        [[RACObserve(self.viewModel, model)filter:^BOOL(id value) {
            @strongify(self);
            return self.viewModel.model.isNotEmpty;
        }]subscribeNext:^(id x) {
            @strongify(self);
            [self.tableView reloadData];
        
        }];
    }
}

//已经有的情况下，修改点击变色
-(void)initIndexPath{
    if (self.clickIndexPath.isNotEmpty) {
        switch (self.clickIndexPath.section) {
            case 0:
            case 1:{
                ColorTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.clickIndexPath];
                [cell.chooseImage setHidden:NO];
                cell.label.textColor = BlueColor447FF5;
            }
                break;
            case 2:{
                ColorDoubleTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.clickIndexPath];
                [cell.chooseImage setHidden:NO];
                cell.name.textColor = BlueColor447FF5;
            }
                break;
            default:
                break;
        }
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.viewModel.model.out_colors.count>0)
    return 3;
    if(self.viewModel.model.out_colors.count>0)
    return 3;
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section  == 0) {
        return 1;
    }else if(section == 1){
        return   self.viewModel.model.out_colors.count;
    }else if(section == 2){
        return   self.viewModel.model.in_colors.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    switch (indexPath.section) {
        case 0:
        {
            NSString *cellid = @"ColorTableView";
            ColorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.image.image = [UIImage imageNamed:@"all_colors"];
            [cell.chooseImage setHidden: YES];
            cell.label.text = @"全部颜色";
            cell.label.textColor = BlackColor333333;
            return cell;
        }
            break;
        case 1:
        {
            NSString *cellid = @"ColorTableViewCell";
            ColorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
            CarColorTypeModel *model =self.viewModel.model.out_colors[indexPath.row];
            cell.label.text = model.name;
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.image setBackgroundColor:[UIColor colorWithString:model.value]];
            [cell.chooseImage setHidden: YES];
            cell.label.textColor = BlackColor333333;
            return cell;
        }
            break;
        case 2:
        {
            NSString *cellid = @"ColorDoubleTableViewCell";
            ColorDoubleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
            
            CarColorTypeModel *model =self.viewModel.model.in_colors[indexPath.row];
            cell.name.text = model.name;
            [cell.chooseImage setHidden: YES];
            cell.name.textColor = BlackColor333333;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSArray *array = [model.value componentsSeparatedByString:@"/"];
            if(array.count>1){
            [cell.image setBackgroundColor:[UIColor colorWithString:[NSString stringWithFormat:@"%@",array[0]]]];
             
            [cell.imageDouble setBackgroundColor:[UIColor colorWithString:[NSString stringWithFormat:@"%@",array[1]]]];
            }else{
                [cell.image setBackgroundColor:[UIColor colorWithString:model.value]];
                [cell.imageDouble setBackgroundColor:[UIColor colorWithString:model.value]];
            }
            return cell;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 53;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return 0;
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else if(section ==1){
        ColorTableViewHeaderFooterView *view = [[ColorTableViewHeaderFooterView alloc] init];
        view.label.text = self.colorlistName[0];
        return view;
    }else if(section ==2){
        ColorTableViewHeaderFooterView *view = [[ColorTableViewHeaderFooterView alloc] init];
        view.label.text = self.colorlistName[1];
        return view;
    }
    return nil;
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.index(indexPath);
    switch (indexPath.section) {
        case 0:{
            CarColorTypeModel *m = [[CarColorTypeModel alloc] init];
            m.color_id =@"";
            self.block(m);
            [self.rt_navigationController popViewControllerAnimated:YES];
        }
            break;
        case 1:{
            CarColorTypeModel *m =self.viewModel.model.out_colors[indexPath.row];
            self.block(m);
            [self.rt_navigationController popViewControllerAnimated:YES];
        }
            break;
        case 2:{
            CarColorTypeModel *m =self.viewModel.model.in_colors[indexPath.row];
            self.block(m);
            [self.rt_navigationController popViewControllerAnimated:YES];
        }

            break;
        default:
            break;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.viewModel.model.isNotEmpty) {
        [self.tableView reloadData];
        [self initIndexPath];
    }
      self.navigationController.navigationBar.translucent = NO;
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
