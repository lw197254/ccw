//
//  VideoDetailViewModel.h
//  chechengwang
//
//  Created by 严琪 on 2017/12/4.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "FatherViewModel.h"
#import "VideoDetailRequest.h"
#import "VideoDetailModel.h"

#import "CommiteListRequest.h"
#import "CommiteListModel.h"

@interface VideoDetailViewModel : FatherViewModel

@property(nonatomic,strong)VideoDetailRequest *request;
@property(nonatomic,strong)VideoDetailModel *data;


@property(nonatomic,strong)CommiteListRequest *videoCommentrequest;
@property(nonatomic,strong)CommiteListModel *list;

@end
