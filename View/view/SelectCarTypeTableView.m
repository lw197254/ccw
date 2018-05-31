//
//  SelectCarTypeTableView.m
//  chechengwang
//
//  Created by 刘伟 on 2017/6/7.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "SelectCarTypeTableView.h"
#import "SelectCarTypeTableViewCell.h"
#import "FindCarByGroupByCarTypeYearModel.h"
#import "CompareDict.h"
#import "CarTypeDetailViewController.h"
@interface SelectCarTypeTableView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)FindCarByGroupByCarTypeYearModel*model;
@property(nonatomic,assign)SelectCarType selectCarType;

@property(nonatomic,assign)NSInteger typeId;
@property(nonatomic,copy)NSString* carSeriesName;

@property(nonatomic,copy)CarTypeCompareSelectedBlock carTypeCompareSelectedBlock;
@property(nonatomic,strong)NSMutableDictionary *selectedDict;
///该方法type目前只支持 SelectCarTypeCompare,//对比，SelectCarTypeSingleSelect//单个选择

@end
@implementation SelectCarTypeTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style carTypeCompareSelectedBlock:(CarTypeCompareSelectedBlock)block type:(SelectCarType)type typeId:(NSInteger )typeId selectedDict:(NSMutableDictionary*)selectedDict carSeriesName:(NSString*)carSeriesName model:(FindCarByGroupByCarTypeYearModel*)model{
    if (self = [super initWithFrame:frame style:style]) {
        self.selectCarType = type;
        self.dataSource = self;
        self.delegate = self;
        [self registerNib:nibFromClass(SelectCarTypeTableViewCell) forCellReuseIdentifier:classNameFromClass(SelectCarTypeTableViewCell)];
        self.selectedDict = selectedDict;
        self.typeId = typeId;
        if (self.carTypeCompareSelectedBlock!=block) {
            self.carTypeCompareSelectedBlock = block;
        }
        self.carSeriesName = carSeriesName;
        self.model = model;
        self.separatorColor = BlackColorE3E3E3;
        self.tableFooterView =[[UIView alloc]initWithFrame:CGRectZero];
    }
    return self;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.model.list.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    FindCarByGroupByCarTypeSectionModel*model =self.model.list[section];
    return model.list.count;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    FindCarByGroupByCarTypeSectionModel*model =self.model.list[section];
    return model.title;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 29;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString*str =classNameFromClass(SelectCarTypeTableViewCell);
    
    SelectCarTypeTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
    
    FindCarByGroupByCarTypeSectionModel*sectionModel =self.model.list[indexPath.section];
    FindCarByGroupByCarTypeGetCarModel*model = sectionModel.list[indexPath.row];
    if (self.selectCarType == SelectCarTypeCompare) {
        if (self.selectedDict) {///对比界面进来的
            if([self.selectedDict objectForKey:model.car_id]){
                cell.disable = YES;
                cell.userInteractionEnabled = NO;
            }else{
                cell.userInteractionEnabled = YES;
                cell.disable = NO;
            }
            
        }else{
            if([[CompareDict shareInstance] objectForKey:model.car_id]){
                cell.disable = YES;
                cell.userInteractionEnabled = NO;
            }else{
                cell.userInteractionEnabled = YES;
                cell.disable = NO;
            }
            
        }
        
    }
    cell.titleLabel.text = model.car_name;
    
    if (model.driving_mode.isNotEmpty) {
        cell.subTitleLabel.text = [NSString stringWithFormat:@"%@ %@", model.driving_mode,model.gearbox];
    }else{
        cell.subTitleLabel.text = [NSString stringWithFormat:@"%@" ,model.gearbox];
    }
    
    cell.priceLabel.text = [model.factory_price stringByAppendingString:@"万"];
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = FontOfSize(14);
    header.contentView.backgroundColor = BlackColorF1F1F1;
    header.textLabel.textColor = BlackColor333333;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FindCarByGroupByCarTypeSectionModel*sectionModel =self.model.list[indexPath.section];
    FindCarByGroupByCarTypeGetCarModel*model = sectionModel.list[indexPath.row];
    
    if (self.selectCarType == SelectCarTypeCompare) {
        if (self.selectedDict) {///对比界面进来的
            if(CompareMaxCount == self.selectedDict.count){
                [[DialogView sharedInstance]showDlg:[Tool currentViewController].view textOnly:[NSString stringWithFormat:@"最多支持%d款车型！",CompareMaxCount] ];
                return;
            }else{
                [self.selectedDict setObject:model.car_id forKey:model.car_id];
            }
            
            if (self.carTypeCompareSelectedBlock) {
                self.carTypeCompareSelectedBlock(model);
                CustomNavigationController*nav = [Tool currentNavigationController ];
                [nav popToViewController:nav.rt_viewControllers[nav.rt_viewControllers.count-1-3] animated:YES];
            }
            
        }else{
            if(CompareMaxCount == [CompareDict shareInstance].count){
                //                对比列表进来的
                [[DialogView sharedInstance]showDlg:[Tool currentViewController].view  textOnly:[NSString stringWithFormat:@"最多支持%d款车型！",CompareMaxCount] ];
                return;
            }
            FindCarByGroupByCarTypeGetCarModel*obj = [[FindCarByGroupByCarTypeGetCarModel alloc]init];
            obj.car_id = model.car_id;
            obj.car_name = [NSString stringWithFormat:@"%@ %@",self.carSeriesName,model.car_name];
            obj.engine_capacity = model.engine_capacity;
            obj.seatnum = model.seatnum;
            
            
            if (self.carTypeCompareSelectedBlock) {
                self.carTypeCompareSelectedBlock(obj);
                CustomNavigationController*nav = [Tool currentNavigationController ];
                [nav popToViewController:nav.rt_viewControllers[nav.rt_viewControllers.count-1-3] animated:YES];
            }
            
        }
        
        
    }else if(self.selectCarType == SelectCarTypeSingleSelect){
        FindCarByGroupByCarTypeGetCarModel*obj = [[FindCarByGroupByCarTypeGetCarModel alloc]init];
        obj.car_id = model.car_id;
        obj.car_name = [NSString stringWithFormat:@"%@ %@",model.car_name,model.engine];
        obj.engine_capacity = model.engine_capacity;
        obj.seatnum = model.seatnum;
        obj.factory_price = model.factory_price;
        
        if (self.carTypeCompareSelectedBlock) {
            self.carTypeCompareSelectedBlock(obj);
            
        }
          CustomNavigationController*nav = [Tool currentNavigationController ];
        [nav popToViewController:nav.rt_viewControllers[nav.rt_viewControllers.count-1-3] animated:YES];
        
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        CarTypeDetailViewController*vc = [[CarTypeDetailViewController alloc]init];
        
        
        vc.chexingId = model.car_id;
         UINavigationController*nav = [Tool currentNavigationController ];
        [nav pushViewController:vc animated:YES];
    }
    
}


@end
