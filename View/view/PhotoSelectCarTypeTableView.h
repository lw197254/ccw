//
//  SelectCarTypeTableView.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/9.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarTypeSectionModel.h"
typedef void (^CarTypeSelectedBlock)(CarTypeModel*model);
@interface PhotoSelectCarTypeTableView : UITableView
@property(nonatomic,strong)CarTypeSectionModel*model;
@property(nonatomic,strong)CarTypeSelectedBlock selectedBlock;
@property(nonatomic,strong)UIImageView *selectedImageView;
@end
