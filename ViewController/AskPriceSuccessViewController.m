//
//  AskPriceSuccessViewController.m
//  chechengwang
//
//  Created by 严琪 on 2017/6/7.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "AskPriceSuccessViewController.h"
#import "TableViewHeaderFooterView.h"


#import "XunjiaTableViewCell.h"
#import "CarDeptViewController.h"
#import "AskForPriceResultListModel.h"
#import "AskForPriceNewViewController.h"

#import "ClueIdObject.h"
@interface AskPriceSuccessViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *selectMoreButton;

@end

@implementation AskPriceSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    
    
    
    [self configUI];
     [self.tableview reloadData];
}



-(void)configUI{
 
  
    self.tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.tableview registerNib:nibFromClass(XunjiaTableViewCell) forCellReuseIdentifier:classNameFromClass(XunjiaTableViewCell)];
    
}



#pragma mark tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.list.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //没有相关车系
    if (self.model.list.count>0) {
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XunjiaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(XunjiaTableViewCell)];
    AskForPriceResultModel*model = self.model.list[indexPath.row];
    if (indexPath.row==0) {
        cell.headerImageViewTopConstraint.constant = 0;
    }else{
        cell.headerImageViewTopConstraint.constant = 10;
    }
    cell.titleLabel.text = model.name;
    cell.priceLabel.text = model.zhidaoprice;
    cell.askPriceButton.tag = indexPath.row;
    [cell.askPriceButton addTarget:self action:@selector(askPriceClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.picurl] placeholderImage:[UIImage imageNamed:@"默认图片80_60"]];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 95-10;
    }
    return  95;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        TableViewHeaderFooterView *headview = [[TableViewHeaderFooterView alloc]initWithFrame:CGRectMake(0, 0, kwidth, 25)];
        headview.noimage =YES;
        headview.image.hidden =YES;
        headview.label.text = @"相关车系推荐";
        [headview.label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headview);
            make.left.equalTo(headview.image).offset(10);
        }];

        [headview.image mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headview.label);
            make.bottom.equalTo(headview.label);
        }];
        headview.label.textColor =BlackColor333333;
        headview.contentView.backgroundColor = [UIColor whiteColor];
        
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
        
        if (font) {
            [headview.label setFont:font];
        }else{
            [headview.label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        }
        return headview;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     AskForPriceResultModel*model = self.model.list[indexPath.row];
    
    CarDeptViewController*vc = [[CarDeptViewController alloc]init];
    vc.chexiid = model.typeid;
    vc.picture = model.picurl;
    [[Tool currentNavigationController ] pushViewController:vc animated:YES];
}
-(void)askPriceClicked:(UIButton*)button{
    [ClueIdObject setClueId:xunjia_161 ];
    
    AskForPriceResultModel*model = self.model.list[button.tag];
    AskForPriceNewViewController*vc = [[AskForPriceNewViewController alloc]init];
  
        vc.carSerieasId = model.typeid;
    vc.imageUrl = model.picurl;
        vc.carTypeName = model.name;

    [self.rt_navigationController pushViewController:vc animated:YES];
}
///继续选车
- (IBAction)selectMoreButtonClicked:(UIButton *)sender {
    UITabBarController* tab = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    CustomNavigationController*nav = tab.viewControllers[tab.selectedIndex];
   
    
    UIViewController*vc = [nav.rt_viewControllers firstObject];
    if (vc.childViewControllers.count >0) {
        [vc.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromParentViewController];
            [obj.view removeFromSuperview];
            
        }];
    }
     [nav dismissViewControllerAnimated:NO completion:nil];
    [nav popToRootViewControllerAnimated:YES complete:^(BOOL finished) {
        [tab setSelectedIndex:1];
    }];
    

   
    
    
    
    
    
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
