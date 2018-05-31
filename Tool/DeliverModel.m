//
//  DeliverModel.m
//  chechengwang
//
//  Created by 严琪 on 2017/4/19.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "DeliverModel.h"
#import "ReadRecordModel.h"

//将请求来的数据做二次数据封装，首页新闻资讯

@implementation DeliverModel

-(NSMutableArray<PicShowModel> *)deliverPicModel:(NSMutableArray<PicShowModel>*) array{
    
    NSArray *models = [ReadRecordModel findAll];
    
    if (array.count>0) {
        for (PicShowModel *model in array) {
            
            model.isRead = notread;
            
            for(ReadRecordModel *art in models){
                if ([model.id isEqualToString:art.id]) {
                    model.isRead = isread;
                    break;
                }
            }
        }
    }
    return array;
}

-(NSMutableArray<InformationModel> *)deliverInformationModel:(NSMutableArray<InformationModel>*) array{
    
    NSArray *models = [ReadRecordModel findAll];
    
    if (array.count>0) {
        for (InformationModel *model in array) {
            
            model.isRead = notread;
            
            for(ReadRecordModel *art in models){
                if ([model.id isEqualToString:art.id]) {
                    model.isRead = isread;
                    break;
                }
            }
        }
    }
    return array;
}

-(NSMutableArray<InfoArticleModel> *)deliverInfoArticleModel:(NSMutableArray<InfoArticleModel>*) array{
    NSArray *models = [ReadRecordModel findAll];
    
    if (array.count>0) {
        for (InfoArticleModel *model in array) {
            
            model.isRead = notread;
            
            for(ReadRecordModel *art in models){
                if ([model.id isEqualToString:art.id]) {
                    model.isRead = isread;
                    break;
                }
            }
        }
    }
    return array;
}

-(NSMutableArray<SubscribeDetailArticleModel> *)deliverSubscribeDetailArticleMode:(NSMutableArray<SubscribeDetailArticleModel> *)array{
    NSArray *models = [ReadRecordModel findAll];
    
    if (array.count>0) {
        for (SubscribeDetailArticleModel *model in array) {
            
            model.isRead = notread;
            
            for(ReadRecordModel *art in models){
                if ([model.id isEqualToString:art.id]) {
                    model.isRead = isread;
                    break;
                }
            }
        }
    }
    return array;
}

@end
