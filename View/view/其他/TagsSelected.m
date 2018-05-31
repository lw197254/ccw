//
//  TagsSelected.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/11.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "TagsSelected.h"
#import "TagsHeaderView.h"
#import "TagsViewTableViewCell.h"

#import "TagsViewModel.h"


#define tags1 @"我的喜好"
#define tags2 @"热门标签"
#define tags3 @"车型标签"



@interface TagsSelected()

@property(nonatomic,strong) TagsViewModel *viewModel;

@end


@implementation TagsSelected

-(instancetype)init{
    if (self = [super init]) {
        
        [[NSBundle mainBundle]loadNibNamed:@"TagsSelected" owner:self options:nil];
        [self addSubview:self.view];
        
        [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.tableView setBackgroundColor:[UIColor whiteColor]];
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        
        [self.tableView registerNib:nibFromClass(TagsViewTableViewCell) forCellReuseIdentifier:classNameFromClass(TagsViewTableViewCell)];
        
        [self.tableView registerClass:[TagsHeaderView class] forHeaderFooterViewReuseIdentifier:classNameFromClass(TagsHeaderView)];
    }
    return self;
}



#pragma 配置

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            if (self.baseModel.userdata.count>0) {
                return 1;
            }
            return 0;
        }
            break;
        case 1:{
            if (self.baseModel.hotdata.count>0) {
                return 1;
            }
            return 0;
        }
            break;
        case 2:{
            if (self.baseModel.cardata.count>0) {
                return 1;
            }
            return 0;
        }
            break;
        default:
            break;
    }
    return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.baseModel isNotEmpty]) {
        return 3;
    }
    // 默认是3个
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TagsViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:classNameFromClass(TagsViewTableViewCell) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 0:
            cell.color = PurpleColorA786FB;
            cell.tags = self.baseModel.userdata;
            cell.defaultClick = YES;
            [cell setTagView:cell.fatherView titleArray:cell.tags];
            break;
        case 1:{
            cell.color = BlueColor6296FE;
            cell.tags = self.baseModel.hotdata;
            [cell setTagView:cell.fatherView titleArray:cell.tags];
        }
            break;
        case 2:{
            cell.color = OrangeColorFF7B68;
            cell.tags = self.baseModel.cardata;
            [cell setTagView:cell.fatherView titleArray:cell.tags];
        }
            break;
        default:
            break;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.baseModel.userdata.count>0) {
            return 50;
        }
        return 0.0001;
    }else if(section == 1){
        if (self.baseModel.hotdata.count>0) {
            return 50;
        }
        return 0.0001;
    }else if(section == 2){
        if (self.baseModel.cardata.count>0) {
            return 50;
        }
        return 0.0001;
    }
    return 0.0001;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TagsHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:classNameFromClass(TagsHeaderView)];
    if (section == 0) {
        if (self.baseModel.userdata.count>0) {
              [view setLabelText:tags1 Color:PurpleColorA786FB];
        }
    }else if(section == 1){
        if (self.baseModel.hotdata.count>0) {
              [view setLabelText:tags2 Color:BlueColor6296FE];
        }
    }else if(section == 2){
        if (self.baseModel.cardata.count>0) {
             [view setLabelText:tags3 Color:OrangeColorFF7B68];
        }
    }
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

-(void)callNet{
    self.viewModel.request.startRequest = YES;
}

-(TagsViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [TagsViewModel SceneModel];
        
        [[RACObserve(_viewModel, data)filter:^BOOL(id value) {
            return _viewModel.data.isNotEmpty;
        }]subscribeNext:^(id x) {
            if (x) {
                self.baseModel = _viewModel.data;
                [self.baseModel sethotandcar];
                [self.tableView reloadData];
            }
        }];
    }
    return _viewModel;
}

-(void)rebuildbaseData{
    NSString *uid = [UserModel shareInstance].uid;
    if (![uid isNotEmpty]) {
        NSString *xihao = [XiHaoClickObject getnames];
        if ([xihao isNotEmpty]) {
            NSArray *temp = [xihao componentsSeparatedByString:@","];
            
            NSMutableArray *temp_hot = [self.baseModel.hotdata copy];
            NSMutableArray *temp_car = [self.baseModel.cardata copy];
            NSMutableArray *temp_user = [NSMutableArray arrayWithCapacity:1];
            
            [temp_hot enumerateObjectsUsingBlock:^(TagsModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [temp enumerateObjectsUsingBlock:^(NSString *nsobj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.name isEqualToString:nsobj]) {
                        [self.baseModel.hotdata removeObject:obj];
                        [temp_user addObject:obj];
                        *stop = YES;
                    }
                }];
            }];
            
            [temp_car enumerateObjectsUsingBlock:^(TagsModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [temp enumerateObjectsUsingBlock:^(NSString *nsobj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.name isEqualToString:nsobj]) {
                        [self.baseModel.cardata removeObject:obj];
                        [temp_user addObject:obj];
                        *stop = YES;
                    }
                }];
            }];
            
            [self.baseModel.userdata addObjectsFromArray:temp_user];
 
        }
        
    }
}



@end
