//
//  CompareViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2017/8/16.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "CompareViewController.h"
#import "CompareImageLineTableViewCell.h"
#import "CompareHeaderView.h"
#import "ComparePriceTableViewCell.h"
#import "CompareKoubeiTableViewCell.h"
#import "CompareDelearTableViewCell.h"
#import "CompareConfigDifferenceTableViewCell.h"
@interface CompareViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableDictionary*stateDict;
@end

@implementation CompareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stateDict = [NSMutableDictionary dictionary];
    [self.tableView registerNib:nibFromClass(CompareImageLineTableViewCell) forCellReuseIdentifier:classNameFromClass(CompareImageLineTableViewCell)];
     [self.tableView registerNib:nibFromClass(ComparePriceTableViewCell) forCellReuseIdentifier:classNameFromClass(ComparePriceTableViewCell)];
      [self.tableView registerNib:nibFromClass(CompareKoubeiTableViewCell) forCellReuseIdentifier:classNameFromClass(CompareKoubeiTableViewCell)];
      [self.tableView registerNib:nibFromClass(CompareDelearTableViewCell) forCellReuseIdentifier:classNameFromClass(CompareDelearTableViewCell)];
    
    [self.tableView registerClass:[CompareConfigDifferenceTableViewCell class] forCellReuseIdentifier:classNameFromClass(CompareConfigDifferenceTableViewCell)];
    [self.tableView registerClass:[CompareHeaderView class] forHeaderFooterViewReuseIdentifier:classNameFromClass(CompareHeaderView)];
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4+3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
           ///车身尺寸
        case 2:
           ///动力性能
        case 3:
            ///排量油耗
            return 4;
            break;
        case 4:
            ////配置差异
            return 11;
            break;
        case 5:
            ////用户口碑
            return 1;
            break;
        case 6:
            ////质量对比
            return 2;
            break;
        case 7:
            ////了解更多
            return 1;
            break;
        default:
            break;
    }
    return 0;
   
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 240;
            break;
        case 1:
            ///车身尺寸
        case 2:
            ///动力性能
        case 3:
            ///排量油耗
            return 70;
            break;
        case 4:
            ////配置差异
            return UITableViewAutomaticDimension;
            break;
        case 5:
            ////用户口碑
            return UITableViewAutomaticDimension;
            break;
        case 6:
            ////质量对比
            return 70;
            break;
        case 7:
            ////了解更多
            return 44;
            break;
        default:
            break;
    }
    return 0;

   
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 180;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
       switch (indexPath.section) {
           case 0:{
               ComparePriceTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(ComparePriceTableViewCell) forIndexPath:indexPath];
//               if (self.stateDict[indexPath]) {
//                   [cell configWithData:NO index:indexPath.row];
//               }else{
//                   [cell configWithData:YES index:indexPath.row];
//                   [self.stateDict setObject:@"" forKey:indexPath];
//               }
               return cell;
              
           }
               
              
            break;
        case 1:
            ///车身尺寸
        case 2:
            ///动力性能
        case 3:
            ///排量油耗
           {
               CompareImageLineTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(CompareImageLineTableViewCell) forIndexPath:indexPath];
               if (self.stateDict[indexPath]) {
                   [cell configWithData:NO index:indexPath.row];
               }else{
                   [cell configWithData:YES index:indexPath.row];
                   [self.stateDict setObject:@"" forKey:indexPath];
               }
               return cell;
           }
            break;
        case 4:
            ////配置差异
           {
               CompareConfigDifferenceTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(CompareConfigDifferenceTableViewCell) forIndexPath:indexPath];
               [cell setData:@"xiaoming,xiaohang,xiaohei,xiaobai" onView:cell.leftTagView];
                [cell setData:@"xiaoming,xiaohang,xiaohei,xiaobai,xiaoming,xiaohang,xiaohei,xiaobai" onView:cell.rightTagView];
            return cell;
           }
            break;
        case 5:
            ////用户口碑「
           {
               CompareKoubeiTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(CompareKoubeiTableViewCell) forIndexPath:indexPath];
               return cell;
           }
               
            
            break;
        case 6:
            ////质量对比
           {
               CompareImageLineTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(CompareImageLineTableViewCell) forIndexPath:indexPath];
               if (self.stateDict[indexPath]) {
                   [cell configWithData:NO index:indexPath.row];
               }else{
                   [cell configWithData:YES index:indexPath.row];
                   [self.stateDict setObject:@"" forKey:indexPath];
               }
               return cell;
           }

            break;
        case 7:
            ////了解更多
          
           {
               CompareDelearTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(CompareDelearTableViewCell) forIndexPath:indexPath];
               return cell;
           }

            
            break;
        default:
            break;
    }

    return nil;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CompareHeaderView*view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:classNameFromClass(CompareHeaderView)];
    if (!view) {
        view = [[CompareHeaderView alloc]initWithReuseIdentifier:classNameFromClass(CompareHeaderView)];
    }
    return view;
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
