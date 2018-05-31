//
//  PublicPraiseTableView.h
//  chechengwang
//
//  Created by 严琪 on 17/1/11.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicPraiseViewModel.h"
#import "PublicPraiseTopViewModel.h"
#import "PublicPraiseTopCheXingViewModel.h"
#import "PublisPraiseCheXingViewModel.h"



@interface PublicPraiseTableView : UITableView<UITableViewDelegate,UITableViewDataSource>
//车系请求
@property(nonatomic,strong)PublicPraiseViewModel *model;
@property(nonatomic,strong)PublicPraiseTopViewModel *topViewModel;
@property(nonatomic,assign)bool isFirstTab;
@property(nonatomic,strong)NSString *s;
-(void)cheXiKouBei;

//车型请求
@property(nonatomic,strong)PublisPraiseCheXingViewModel *cxingmodel;
@property(nonatomic,strong)PublicPraiseTopCheXingViewModel *topcxingViewModel;
@property(nonatomic,assign)bool isChexingTab;
-(void)cheXingKouBei;

@property(nonatomic,assign)NSInteger page;

 
@end
