//
//  DeliverModel.h
//  chechengwang
//
//  Created by 严琪 on 2017/4/19.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PicShowModel.h"
#import "InfoArticleModel.h"
#import "InformationModel.h"

#import "SubscribeDetailArticleModel.h"

@interface DeliverModel : NSObject

-(NSMutableArray<PicShowModel> *)deliverPicModel:(NSMutableArray<PicShowModel>*) array;
-(NSMutableArray<InfoArticleModel> *)deliverInfoArticleModel:(NSMutableArray<InfoArticleModel>*) array;

-(NSMutableArray<InformationModel> *)deliverInformationModel:(NSMutableArray<InformationModel>*) array;

-(NSMutableArray<SubscribeDetailArticleModel> *)deliverSubscribeDetailArticleMode:(NSMutableArray<SubscribeDetailArticleModel>*) array;

@end
