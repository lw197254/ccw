//
//  UIView+Shadow.m
//  chechengwang
//
//  Created by 刘伟 on 2017/6/23.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "UIView+Shadow.h"

@implementation UIView (Shadow)
-(void)addShadow{
    self.layer.shadowOpacity = 0.5;// 阴影透明度
    
    self.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    
    self.layer.shadowRadius = 3;// 阴影扩散的范围控制
    
    self.layer.shadowOffset  = CGSizeMake(1, 1);// 阴影的范围
}
@end
