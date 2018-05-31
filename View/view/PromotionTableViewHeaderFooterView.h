//
//  PromotionTableViewHeaderFooterView.h
//  chechengwang
//
//  Created by 严琪 on 17/3/6.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PromotionSaleCarModel.h"
@interface PromotionTableViewHeaderFooterView : UITableViewHeaderFooterView
@property(nonatomic,strong)IBOutlet UIView*view;
-(void)setData:(PromotionSaleCarModel *)model Count:(NSInteger) count;
@property(nonatomic,assign)BOOL hideList;
@property (weak, nonatomic) IBOutlet UIButton *button;
@end
