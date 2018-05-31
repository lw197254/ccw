//
//  FatherViewModel.h
//  PrivateOrdering
//
//  Created by 刘伟 on 16/3/21.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "SceneModel.h"
#import "FatherRequest.h"
#import "MyAction.h"
@interface FatherViewModel : SceneModel<ActionDelegate>

+(instancetype)viewModel;
///标志数据绑定是否完成

//上传请求
-(void)upload:(Request*)request;
///展示错误信息的view
@property(nonatomic,strong)UIView*view;
//- (void)SEND_ACTION:(Request *)req;
-(NSMutableArray *)success:(NSMutableArray *)originArray
                  newArray:(NSArray *)newArray currentPage:(NSInteger)currentPage initPage:(NSInteger)initPage;
@end
