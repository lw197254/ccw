//
//  ParameterConfigViewController.h
//  chechengwang
//
//  Created by 刘伟 on 2017/1/10.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"

@interface ParameterConfigViewController : ParentViewController
@property(nonatomic,copy)NSString*typeId;
///int	车型id （车系id, 车型id传一个即可）
@property(nonatomic,strong)NSArray<NSString*>*carIds;
@property(nonatomic,assign)BOOL isCompare;
@end
