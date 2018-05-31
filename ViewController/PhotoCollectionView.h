//
//  PhotoUICollectionView.h
//  chechengwang
//
//  Created by 严琪 on 17/1/9.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoViewModel.h"
#import "PicMenuModel.h"

typedef void(^Blo)(NSMutableArray<PicModel*> *pic,NSString *catgoryId);
typedef void(^BloNum)(NSInteger count);

@interface PhotoCollectionView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) PhotoViewModel *model;
@property(nonatomic,strong)NSString *typeId;
@property(nonatomic,strong)NSString *carId;
@property(nonatomic,strong)NSString *catgoryId;

@property(nonatomic,strong)NSString *colorId;

@property(nonatomic,strong)NSArray<PicMenuModel*> *menu;

@property(nonatomic,strong)NSString *carName;
@property(nonatomic,strong)NSString *carType;
@property(nonatomic,strong)NSString *carPrice;

//头部selectlist 选中按钮
@property(nonatomic,assign)NSInteger labelCurrentNumber;
//头部selectlist 选中按钮名称
@property(nonatomic,strong)NSString* labelCurrentName;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,copy)Blo block;

@property(nonatomic,copy)BloNum blockNum;

//初始化的图片列表
@property (nonatomic,strong)NSMutableDictionary* forestalllDict;

-(void)headerRefresh;
-(void)changeView;

@end
