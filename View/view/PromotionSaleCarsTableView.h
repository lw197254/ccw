//
//  PromotionSaleCarsTableView.h
//  chechengwang
//
//  Created by 严琪 on 17/3/10.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PromotionSaleCarModel.h"

@interface PromotionSaleCarsTableView : UITableView<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSString *dealer;
-(void)setData:(PromotionSaleCarModel *)model;
@end
