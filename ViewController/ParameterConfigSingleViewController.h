//
//  ParameterConfigSingleViewController.h
//  chechengwang
//
//  Created by 刘伟 on 2017/6/26.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "ParentViewController.h"
///车型参数配置
@interface ParameterConfigSingleViewController : ParentViewController
///车系id
@property(nonatomic,copy)NSString*typeId;
///int	车型id （车系id, 车型id传一个即可）
@property(nonatomic,copy)NSString*carId;
@property(nonatomic,copy)NSString*carTypeName;
@end
