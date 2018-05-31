//
//  InfoDetailsViewController.h
//  chechengwang
//
//  Created by 严琪 on 16/12/28.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"

typedef NS_ENUM(NSInteger,FATHERINFOCONTROLLER)
{
    INFOMESSAGECONTROLLER=10,
    INFONORMALCONTROLLER=11
};

@class PicShowModel;
@class  ShadowLoginViewController;

@interface InfoDetailsViewController : ParentViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSString *aid;
///分享相关的属性
@property(nonatomic,strong)PicShowModel *listInfo;
///文章类型
@property(nonatomic,copy)NSString *arttype;


@property(nonatomic,assign)FATHERINFOCONTROLLER fatherControllerType;
@end
