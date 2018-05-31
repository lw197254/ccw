//
//  CompareTableView.m
//  chechengwang
//
//  Created by 严琪 on 2017/8/21.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "CompareTableView.h"

#import "CompareImageLineTableViewCell.h"
#import "CompareHeaderView.h"
#import "CompareSubtitleHeaderView.h"
#import "ComparePriceTableViewCell.h"
#import "CompareKoubeiTableViewCell.h"
#import "CompareDelearTableViewCell.h"
#import "CompareConfigDifferenceTableViewCell.h"
#import "CompareTopView.h"
#import "ComparePriceView.h"
#import "CompareKoubeiView.h"



#import "CompareCar.h"
#import "CompareBudget.h"
#import "CompareConfig.h"
#import "CompareKoubei.h"
#import "NewCompareCarListModel.h"
#import "NewCompareCarModel.h"
#import "CompareBodySizeChild.h"

#import "ParamsCompareTool.h"
#import "BuyCarCalculatorDataModel.h"
#import "BuyCarCalculatorViewController.h"
#import "PublicPraiseDetailViewController.h"
#import "CompareMoreHeaderFooterView.h"

#import "ParameterConfigViewController.h"


@interface CompareTableView()
@property(nonatomic,strong)NSMutableDictionary*stateDict;

@property(nonatomic,strong)ParamsCompareTool *paramsTool;

@property(nonatomic,assign)bool isshwoAllDiff;

@end

@implementation CompareTableView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        [self loadView];
//        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}


-(instancetype)init{
    if (self = [super init]) {
//        [self loadView];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

-(void)loadView{
    
    self.stateDict = [NSMutableDictionary dictionary];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.mas_equalTo(kheight-64);
    }];
    
    [self.tableView registerNib:nibFromClass(CompareImageLineTableViewCell) forCellReuseIdentifier:classNameFromClass(CompareImageLineTableViewCell)];
    [self.tableView registerNib:nibFromClass(ComparePriceTableViewCell) forCellReuseIdentifier:classNameFromClass(ComparePriceTableViewCell)];
    [self.tableView registerNib:nibFromClass(CompareKoubeiTableViewCell) forCellReuseIdentifier:classNameFromClass(CompareKoubeiTableViewCell)];
    [self.tableView registerNib:nibFromClass(CompareDelearTableViewCell) forCellReuseIdentifier:classNameFromClass(CompareDelearTableViewCell)];
    
    [self.tableView registerClass:[CompareConfigDifferenceTableViewCell class] forCellReuseIdentifier:classNameFromClass(CompareConfigDifferenceTableViewCell)];
    [self.tableView registerClass:[CompareHeaderView class] forHeaderFooterViewReuseIdentifier:classNameFromClass(CompareHeaderView)];
    
    [self.tableView registerClass:[CompareSubtitleHeaderView class] forHeaderFooterViewReuseIdentifier:classNameFromClass(CompareSubtitleHeaderView)];
    
    [self.tableView registerClass:[CompareMoreHeaderFooterView class] forHeaderFooterViewReuseIdentifier:classNameFromClass(CompareMoreHeaderFooterView)];
    
    UIView *tableViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kwidth, 180)];

    self.tableView.tableHeaderView = tableViewHeader;
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
}

-(void)loadTableView{
    [self initShowMoreData];
    [self.tableView reloadData];
}


-(void)initShowMoreData{
    [self.paramsTool removeAll];
    
    NewCompareCarModel *model1 = self.data.data[0];
    self.paramsTool.leftParams = model1.config.configuration_difference;
    
    if (self.data.data.count>1) {
 
        NewCompareCarModel *model2 = self.data.data[1];
        self.paramsTool.rightParams = model2.config.configuration_difference;
        
        [self.paramsTool checkEachOther];
        self.isshwoAllDiff = [self.paramsTool isShowFooter];
    }else{
        //如果右边为空，直接可以让他全部显示
        self.paramsTool.rightParams = nil;
        [self.paramsTool checkEachOther];
        self.isshwoAllDiff = YES;
    }
    
}

#pragma mark tableviewDelagete
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([self.data.data isNotEmpty]){
    return 4+3;
    }else{
        return 0;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:{
            ///车身尺寸
            NewCompareCarModel *model = self.data.data[0];
            return model.config.body_size.confs.count;
            break;
        }
        case 2:{
            NewCompareCarModel *model = self.data.data[0];
            return model.config.dynamic_performance.confs.count;
            break;
        }
            ///动力性能
        case 3:{
            ///排量油耗
            NewCompareCarModel *model = self.data.data[0];
            return model.config.oil_wear.confs.count;
            break;
        }
        case 4:
            ////配置差异
        {
            return self.paramsTool.count>0?1:0;
    }
            break;
        case 5:
            ////用户口碑
            return 1;
            break;
        case 6:
            ////质量对比
            return 1;
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
            //
        case 0:
            return UITableViewAutomaticDimension;
            break;
        case 1:
            ///车身尺寸
        case 2:
            ///动力性能
        case 3:
            ///排量油耗
            return 50;
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
            return 44;
            break;
        case 7:
            ////了解更多
            return UITableViewAutomaticDimension;
            break;
        default:
            break;
    }
    return 0;
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    switch (section) {
        case 4:
        {
            CompareMoreHeaderFooterView*view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:classNameFromClass(CompareMoreHeaderFooterView)];
            if (!view) {
                view = [[CompareMoreHeaderFooterView alloc]initWithReuseIdentifier:classNameFromClass(CompareMoreHeaderFooterView)];
            }
            [view.moreButton addTarget:self action:@selector(gotoMoreCar) forControlEvents:UIControlEventTouchUpInside];
            [view setTopLine];
            [view setBottomLine];
            return view;

        }
            break;
            
        default:
            break;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    switch (section) {
        case 4:
        {
            return 50;
        }
            break;
            
        default:
            break;
    }
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
            //
        case 0:
            return 40;
            break;
        case 1:
            ///车身尺寸
            return 80;
            break;
        case 2:
            ///动力性能
        case 3:
            ///排量油耗
            return 40;
            break;
        case 4:
            ////配置差异
            return 40;
            break;
        case 5:
            ////用户口碑
            return 50;
            break;
        case 6:
            ////质量对比
            ////了解更多
            return 60;
            break;
        case 7:
            ////了解更多
            return 0.0001;
            break;
        default:
            break;
    }
    return 0.0001;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            ComparePriceTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(ComparePriceTableViewCell) forIndexPath:indexPath];
            NewCompareCarModel *car1 = self.data.data[0];

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        
            float car1Zongjia = [self updateDataModel:car1.budget.factory_price];
//            cell.leftPriceView.priceLabel.formatBlock = ^NSString* (CGFloat value)
//            {
//                
//                return [NSString stringWithFormat:@"%0.2f万",value];
//            };
//            cell.leftPriceView.priceLabel.method = UILabelCountingMethodEaseOut;
//            [cell.leftPriceView.priceLabel countFrom:1.0 to:car1Zongjia withDuration:1.0];
            
            cell.leftPriceView.priceLabel.text = [NSString stringWithFormat:@"%0.2f万",car1Zongjia];
            cell.leftPriceView.carPriceLabel.text = [car1.budget.factory_price stringByAppendingString:@"万"];
            
            cell.leftPriceView.model = car1;
            
            
            if (self.data.data.count>1) {
                NewCompareCarModel *car2 = self.data.data[1];
                float car2Zongjia = [self updateDataModel:car2.budget.factory_price];
                cell.righPricetView.priceLabel.text = [NSString stringWithFormat:@"%0.2f万",car2Zongjia];
                cell.righPricetView.carPriceLabel.text = [car2.budget.factory_price stringByAppendingString:@"万"];
                cell.righPricetView.model = car2;
                
                [cell.righPricetView.priceDetailButton setTitleColor:BlackColor333333 forState:UIControlStateNormal];
                [cell.righPricetView.askPriceButton setAlpha:1.0];
                [cell.righPricetView.backgroundImageView setImage:[UIImage imageNamed:@"bg_pk无内容"]];
                [cell.righPricetView choosePinkColor];
            }else{
                 cell.righPricetView.model = nil;
                 cell.righPricetView.priceLabel.text = @"--";
                 cell.righPricetView.carPriceLabel.text = @"--万";
                 [cell.righPricetView.priceDetailButton setTitleColor:BlackColor999999 forState:UIControlStateNormal];
                [cell.righPricetView.askPriceButton setAlpha:0.4];
                [cell.righPricetView.backgroundImageView setImage:[UIImage imageNamed:@"bg_pk无内容"]];
            }

   
         
            return cell;
            
        }
            break;
        case 1:
            ///车身尺寸
            ///排量油耗
        {
            CompareImageLineTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(CompareImageLineTableViewCell) forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NewCompareCarModel *model1 = self.data.data[0];
            CompareBodySizeChild *child1 = model1.config.body_size.confs[indexPath.row];
            
            cell.leftlabel.text = child1.value;
            cell.middlelabel.text = child1.name;
            
            //还有一个参数数据
            NewCompareCarModel *model2;
            CompareBodySizeChild *child2;
            
            float value = 0.0;
            
            if (self.data.data.count>1) {
                model2 = self.data.data[1];
                child2 = model2.config.body_size.confs[indexPath.row];

                cell.rightlabel.text = child2.value;
                
                int dividend = [child1.value intValue]+[child2.value intValue];
                int denominator = [child1.value intValue];
                value = denominator*1.0/dividend;
            }else{
                value = 0.5;
                cell.rightlabel.text = @"-";
            }
            
            
            
            
            if (self.stateDict[indexPath]) {
                [cell configWithData:NO float:value];
            }else{
                [cell configWithData:YES float:value];
                [self.stateDict setObject:@"" forKey:indexPath];
            }
            return cell;
        }
            break;

        case 2:
            ///动力性能
        {
            CompareImageLineTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(CompareImageLineTableViewCell) forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NewCompareCarModel *model1 = self.data.data[0];
            CompareBodySizeChild *child1 = model1.config.dynamic_performance.confs[indexPath.row];
            
            cell.leftlabel.text = child1.value;
            cell.middlelabel.text = child1.name;
            
            //还有一个参数数据
            NewCompareCarModel *model2;
            CompareBodySizeChild *child2;
            
            float value = 0.0;
            
            if (self.data.data.count>1) {
                model2 = self.data.data[1];
                child2 = model2.config.dynamic_performance.confs[indexPath.row];
                
                cell.rightlabel.text = child2.value;
                
                int dividend = [child1.value intValue]+[child2.value intValue];
                int denominator = [child1.value intValue];
                value = denominator*1.0/dividend;
            }else{
                value = 0.5;
                cell.rightlabel.text = @"-";
            }
            
            
            
            
            if (self.stateDict[indexPath]) {
                [cell configWithData:NO float:value];
            }else{
                [cell configWithData:YES float:value];
                [self.stateDict setObject:@"" forKey:indexPath];
            }
            return cell;
        }
            break;

        case 3:
            ///排量油耗
        {
            CompareImageLineTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(CompareImageLineTableViewCell) forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NewCompareCarModel *model1 = self.data.data[0];
            CompareBodySizeChild *child1 = model1.config.oil_wear.confs[indexPath.row];
            
            cell.leftlabel.text = child1.confs;
            cell.middlelabel.text = child1.value;
            
            //还有一个参数数据
            NewCompareCarModel *model2;
            CompareBodySizeChild *child2;
            
            float value = 0.5;
            
            if (self.data.data.count>1) {
                model2 = self.data.data[1];
                child2 = model2.config.oil_wear.confs[indexPath.row];
                
                cell.rightlabel.text = child2.confs;
            }else{
                value = 0.5;
                cell.rightlabel.text = @"-";
            }
            
            
            
            
            if (self.stateDict[indexPath]) {
                [cell configWithData:NO float:value];
            }else{
                [cell configWithData:YES float:value];
                [self.stateDict setObject:@"" forKey:indexPath];
            }
            return cell;
        }
            break;
        case 4:
            ////配置差异
        {
            CompareConfigDifferenceTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(CompareConfigDifferenceTableViewCell) forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (self.isshwoAllDiff) {
                [cell isneedShowButton:YES];
                [cell.moreButton addTarget:self action:@selector(changeDiff:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell setData:[self.paramsTool getSmallLeftParams] onView:cell.leftTagView];
                [cell setData:[self.paramsTool getSmallRighParams] onView:cell.rightTagView];
            }else{
                [cell setData:[self.paramsTool getLeftParams] onView:cell.leftTagView];
                [cell setData:[self.paramsTool getRightParams] onView:cell.rightTagView];
            }
            
           
            return cell;
        }
            break;
        case 5:
            ////用户口碑「
        {
            CompareKoubeiTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(CompareKoubeiTableViewCell) forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NewCompareCarModel *model1 = self.data.data[0];
            CompareKoubei *child1 = model1.koubei;
            
            
            if ([child1 isNotEmpty]) {
                
                if ([child1.scontent isNotEmpty]) {
                    NSString *info =[child1.scontent stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                    info = [info stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    info = [info stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                    cell.leftView.koubeiDetailLabel.text = info;
                    cell.leftView.car = model1;
                    [cell.leftView.ratingBar displayRating:[child1.star floatValue]];
                    cell.leftView.koubeiLabel.text = child1.star;
                    [cell.leftView.moreKoubeiButton setTitleColor:BlueColor447FF5 forState:UIControlStateNormal];
                    [cell.leftView.moreKoubeiButton setImage:[UIImage imageNamed:@"箭头向右蓝"] forState:UIControlStateNormal];

                }else{
                    cell.leftView.car = nil;
                    cell.leftView.koubeiLabel.text = @"暂无评分";
                    cell.leftView.koubeiDetailLabel.text = @"暂无口碑";
                    [cell.leftView.ratingBar displayRating:0.0];
                    [cell.leftView.moreKoubeiButton setTitleColor:BlackColor999999 forState:UIControlStateNormal];
                    [cell.leftView.moreKoubeiButton setImage:[UIImage imageNamed:@"箭头向右"] forState:UIControlStateNormal];
                }
    
              
            }else{
                cell.leftView.car = nil;
                cell.leftView.koubeiLabel.text = @"暂无评分";
                cell.leftView.koubeiDetailLabel.text = @"暂无口碑";
                [cell.leftView.ratingBar displayRating:0.0];
                [cell.leftView.moreKoubeiButton setTitleColor:BlackColor999999 forState:UIControlStateNormal];
                [cell.leftView.moreKoubeiButton setImage:[UIImage imageNamed:@"箭头向右"] forState:UIControlStateNormal];
            }
            //还有一个参数数据
            NewCompareCarModel *model2;
            CompareKoubei *child2;
            
          
            
            if (self.data.data.count>1) {
                model2 = self.data.data[1];
                child2 = model2.koubei;
                
                
                if ([child2.scontent isNotEmpty]) {
                    NSString *info =[child2.scontent stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                    info = [info stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    info = [info stringByReplacingOccurrencesOfString:@"\r" withString:@""];

                    cell.rightView.car = model2;
                    cell.rightView.koubeiLabel.text = child2.star;
                    [cell.rightView.ratingBar displayRating:[child2.star floatValue]];
                    cell.rightView.koubeiDetailLabel.text = info;
                    [cell.rightView.moreKoubeiButton setTitleColor:BlueColor447FF5 forState:UIControlStateNormal];
                    [cell.rightView.moreKoubeiButton setImage:[UIImage imageNamed:@"箭头向右蓝"] forState:UIControlStateNormal];

                }else{
                    cell.rightView.car = nil;
                    [cell.rightView.ratingBar displayRating:0.0];
                    cell.rightView.koubeiLabel.text = @"暂无评分";
                    cell.rightView.koubeiDetailLabel.text = @"暂无口碑";
                    [cell.rightView.moreKoubeiButton setTitleColor:BlackColor999999 forState:UIControlStateNormal];
                    [cell.rightView.moreKoubeiButton setImage:[UIImage imageNamed:@"箭头向右"] forState:UIControlStateNormal];
                }

                
       
            }else{
                cell.rightView.koubeiLabel.text = @"暂无评分";
                cell.rightView.koubeiDetailLabel.text = @"暂无口碑";
                [cell.rightView.moreKoubeiButton setTitleColor:BlackColor999999 forState:UIControlStateNormal];
                  [cell.rightView.moreKoubeiButton setImage:[UIImage imageNamed:@"箭头向右"] forState:UIControlStateNormal];
                [cell.rightView.ratingBar displayRating:0.0];
                cell.rightView.car = nil;
            }
            
            
            
            return cell;

        }
            
            
            break;
        case 6:
            ////质量对比
        {
//            CompareImageLineTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(CompareImageLineTableViewCell) forIndexPath:indexPath];
//            if (self.stateDict[indexPath]) {
//                [cell configWithData:NO index:indexPath.row];
//            }else{
//                [cell configWithData:YES index:indexPath.row];
//                [self.stateDict setObject:@"" forKey:indexPath];
//            }
//            return cell;
            CompareDelearTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(CompareDelearTableViewCell) forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NewCompareCarModel *model1 = self.data.data[0];
            cell.leftid = model1.cars.car_id;
            
            if ([cell.leftid isNotEmpty]) {
                  cell.leftid = model1.cars.car_id;
                [cell.leftButton setEnabled:YES];
            }else{
                cell.leftid = @"";
                [cell.leftButton setEnabled:NO];
            }
            
            if (self.data.data.count>1) {
                NewCompareCarModel *model2 = self.data.data[1];
                cell.rightid = model2.cars.car_id;
                [cell.rightButton setEnabled:YES];
            }else{
                cell.rightid = @"";
                [cell.rightButton setEnabled:NO];
            }
            
            return cell;
        }
            
            break;
        case 7:
            ////了解更多
            
        {
            CompareDelearTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(CompareDelearTableViewCell) forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NewCompareCarModel *model1 = self.data.data[0];
            cell.leftid = model1.cars.car_id;
            
            if (self.data.data.count>0) {
                NewCompareCarModel *model2 = self.data.data[2];
                 cell.rightid = model2.cars.car_id;
            }
            
            return cell;
        }
            
            
            break;
        default:
            break;
    }
    
    return nil;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case 0:{
            CompareSubtitleHeaderView*view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:classNameFromClass(CompareSubtitleHeaderView)];
            if (!view) {
                view = [[CompareSubtitleHeaderView alloc]initWithReuseIdentifier:classNameFromClass(CompareSubtitleHeaderView)];
            }
            NSString *title = @"购车预算";
            view.subTitleLabel.text = title;
            return view;
        }
            break;
        case 1:{
            CompareHeaderView*view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:classNameFromClass(CompareHeaderView)];
            if (!view) {
                view = [[CompareHeaderView alloc]initWithReuseIdentifier:classNameFromClass(CompareHeaderView)];
            }
            ///车身尺寸
            NewCompareCarModel *model = self.data.data[0];
            NSString *title = model.config.config_diff;
            view.titleLabel.text = title;
            NSString *subtitle = model.config.body_size.value;
            view.subTitleLabel.text = subtitle;
            return view;
            break;
        }
        case 2:{
            
            CompareSubtitleHeaderView*view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:classNameFromClass(CompareSubtitleHeaderView)];
            if (!view) {
                view = [[CompareSubtitleHeaderView alloc]initWithReuseIdentifier:classNameFromClass(CompareSubtitleHeaderView)];
            }
            [view.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(view);
                make.bottom.equalTo(view);
            }];
            NewCompareCarModel *model = self.data.data[0];
            NSString *subtitle = model.config.dynamic_performance.value;
            view.subTitleLabel.text = subtitle;
            return view;
            break;
        }
            ///动力性能
        case 3:{
            ///排量油耗
            CompareSubtitleHeaderView*view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:classNameFromClass(CompareSubtitleHeaderView)];
            if (!view) {
                view = [[CompareSubtitleHeaderView alloc]initWithReuseIdentifier:classNameFromClass(CompareSubtitleHeaderView)];
            }
            [view.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(view);
                make.bottom.equalTo(view);
            }];
            NewCompareCarModel *model = self.data.data[0];
            NSString *subtitle = model.config.oil_wear.value;
            view.subTitleLabel.text = subtitle;
            return view;
            break;
        }
        case 4:
            ////配置差异
        {
            CompareSubtitleHeaderView*view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:classNameFromClass(CompareSubtitleHeaderView)];
            if (!view) {
                view = [[CompareSubtitleHeaderView alloc]initWithReuseIdentifier:classNameFromClass(CompareSubtitleHeaderView)];
            }
            [view.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(view);
                make.bottom.equalTo(view);
            }];
            NewCompareCarModel *model = self.data.data[0];
            NSString *subtitle = model.config.configuration_difference.value;
            view.subTitleLabel.text = subtitle;
            return view;
        }
            break;
        case 5:
            ////用户口碑
        {  CompareSubtitleHeaderView*view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:classNameFromClass(CompareSubtitleHeaderView)];
            if (!view) {
                view = [[CompareSubtitleHeaderView alloc]initWithReuseIdentifier:classNameFromClass(CompareSubtitleHeaderView)];
            }
            NSString *title = @"用户口碑";
 
            [view.subTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(view);
            }];
            [view.subTitleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
            
            view.subTitleLabel.text = title;
            return view;
        }
            break;
        case 6:
            ////质量对比
        {
            CompareSubtitleHeaderView*view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:classNameFromClass(CompareSubtitleHeaderView)];
            if (!view) {
                view = [[CompareSubtitleHeaderView alloc]initWithReuseIdentifier:classNameFromClass(CompareSubtitleHeaderView)];
            }
            [view.subTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(view);
            }];
            
            NSString *title = @"了解更多";
            view.subTitleLabel.text = title;
            [view.subTitleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
            return view;
    }
    
            break;
        case 7:
            ////了解更多
            return nil;
            break;
        default:
            break;
    }
    return nil;

}


#pragma mark 点击事件

-(void)changeDiff:(UIButton *)button{
    button.selected = self.isshwoAllDiff;
    self.isshwoAllDiff = !self.isshwoAllDiff;
    [self.tableView reloadData];
}

-(void)gotoMoreCar{
    ParameterConfigViewController *vc= [[ParameterConfigViewController alloc] init];
    [[Tool currentNavigationController].rt_navigationController pushViewController:vc animated:YES];
}



#pragma mark 让tableview拿不到方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat placeHolderHeight = 180 - 95;
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY >= 0 && offsetY <= placeHolderHeight) {
        self.topView.transform = CGAffineTransformMakeTranslation(0, -offsetY);
        [self.topView reloadCollectionWithType:@"showImage"];
    }
    else if (offsetY > placeHolderHeight) {
        self.topView.transform = CGAffineTransformMakeTranslation(0, -placeHolderHeight);
        [self.topView reloadCollectionWithType:@"showTitle"];
       
    }
    else if (offsetY <0) {
        self.topView.transform = CGAffineTransformMakeTranslation(0, -offsetY);
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.tbDelegate setTableWay:NO];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self.tbDelegate setTableWay:NO];
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

#pragma mark 懒加载
-(ParamsCompareTool *)paramsTool{
    if (!_paramsTool) {
        _paramsTool = [[ParamsCompareTool alloc] init];
    }
    return _paramsTool;
}


#pragma mark 计算全款价格
-(float)updateDataModel:(NSString *)price{
    
    BuyCarCalculatorDataModel*dataModel = [[BuyCarCalculatorDataModel alloc] init];
    
    if (price.isNotEmpty) {
        dataModel.luoCheJiaGe = [price floatValue]*10000;
    }else{
        dataModel.luoCheJiaGe =0;
    }

    dataModel.jiaoQiangXianZuoWei = JiaoQiangXianZuoWei1_5;

    dataModel.cheShangRenYuanShuNumber = 4;
    dataModel.paiLiangQuJian = paiLiangQuJian1_6_2_0L;

    float zongjia = floor((dataModel.zongJia)*1)/10000;
    return zongjia;
    
}

@end
