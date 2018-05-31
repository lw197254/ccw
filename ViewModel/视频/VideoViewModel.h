//
//  VideoViewModel.h
//  chechengwang
//
//  Created by 严琪 on 2017/12/1.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "FatherViewModel.h"
#import "VideoListRequest.h"
#import "VideoLabelRequest.h"

#import "VideoLabelListModel.h"
#import "VideoListModel.h"

@interface VideoViewModel : FatherViewModel

@property (nonatomic,strong) VideoListRequest *listRequest;
@property (nonatomic,strong) VideoLabelRequest *labelRequest;

@property (nonatomic,copy) VideoListModel *info;
@property (nonatomic,copy) VideoLabelListModel *labelinfo;
@end
