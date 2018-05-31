//
//  UserInfoViewModel.h
//  12123
//
//  Created by 琪琪雪雪 on 16/10/27.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "FatherViewModel.h"
#import "UserModel.h"
#import "UpdateUserInfoRequest.h"
#import "UploadHeadImageRequest.h"

@interface UserInfoViewModel : FatherViewModel
@property(nonatomic,strong)UpdateUserInfoRequest *request;
@property(nonatomic,strong)UploadHeadImageRequest *uploadHeadImageRequest;

@end
