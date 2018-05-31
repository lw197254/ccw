//
//  PhotoViewModel.h
//  chechengwang
//
//  Created by 严琪 on 17/1/9.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "PhotoFatherModel.h"
#import "PhotoRequest.h"

@interface PhotoViewModel : FatherViewModel
@property(nonatomic,strong)PhotoRequest *request;
//@property(nonatomic,strong)PhotoFatherModel *model;
@property(nonatomic,strong)NSMutableDictionary*modelDict;

@end
