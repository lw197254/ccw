//
//  InfoNewSonModel.h
//  chechengwang
//
//  Created by 严琪 on 16/12/30.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "FatherModel.h"
#import "PicModel.h"

@protocol  InfoNewSonModel
@end


@interface InfoNewSonModel : FatherModel
@property(nonatomic,strong)NSString *brand_son_id;
@property(nonatomic,strong)NSString *brand_son_name;
@property(nonatomic,strong)NSString *factory_price;

@property(nonatomic,strong)PicModel *pic;
@end
