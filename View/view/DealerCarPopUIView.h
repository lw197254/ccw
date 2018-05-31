//
//  DealerCarPopUIView.h
//  chechengwang
//
//  Created by 严琪 on 17/3/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PromotionCarList.h"
#import "PromotionCarModel.h"

typedef void(^callSrevice)(PromotionCarModel *model);
@interface DealerCarPopUIView : UIView
-(void)SetDataList:(NSArray<PromotionCarList> *) model;
@property(nonatomic,strong)UIButton *close;
@property(nonatomic,strong)UIButton *button;

@property(nonatomic,strong)callSrevice CallService;
@property(nonatomic,strong)NSString *delearId;
@end
