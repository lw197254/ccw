//
//  HotBrandView.h
//  chechengwang
//
//  Created by 刘伟 on 2017/3/21.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>



#import "BrandModel.h"
#define itemCountInRow 5
@interface HotBrandItem :UIView
@property(nonatomic,strong)UIImageView*imageView;
@property(nonatomic,strong)UIButton*button;
@property(nonatomic,strong)UILabel*label;
@end
typedef void(^HotBrandTableViewCellItemClickedBlock)(HotBrandItem*item,NSInteger index);
@interface HotBrandView : UIView

-(void)setCellWithArray:(NSArray<BrandModel*>*)array itemClickBlock:(HotBrandTableViewCellItemClickedBlock)block;

@end
