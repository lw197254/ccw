//
//  SubjectDetailViewController.h
//  chechengwang
//
//  Created by 严琪 on 17/4/10.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ParentViewController.h"

typedef NS_ENUM(NSInteger,FATHERCONTROLLER)
{
    MESSAGECONTROLLER=10,
    NORMALCONTROLLER=11
};

@class PicShowModel;

@interface SubjectDetailViewController : ParentViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSString *aid;
///分享相关的属性
@property(nonatomic,strong)PicShowModel *listInfo;
///文章类型
@property(nonatomic,copy)NSString *arttype;

@property(nonatomic,assign)FATHERCONTROLLER fatherControllerType;
@end
