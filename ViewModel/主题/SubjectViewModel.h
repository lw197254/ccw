//
//  SubjectViewModel.h
//  chechengwang
//
//  Created by 严琪 on 2017/12/14.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "FatherViewModel.h"

#import "SubjectRequest.h"
#import "XiHaoSubjectModel.h"
#import "XiHaoSubjectListModel.h"

@interface SubjectViewModel : FatherViewModel

@property (nonatomic,strong) SubjectRequest *request;
@property (nonatomic,strong) XiHaoSubjectModel *data;

@property (nonatomic,strong )XiHaoSubjectListModel *listdata;

@end
