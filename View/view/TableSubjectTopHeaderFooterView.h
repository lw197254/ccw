//
//  TableSubjectTopHeaderFooterView.h
//  chechengwang
//
//  Created by 严琪 on 17/4/10.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoBaseModel.h"

#import "SubjectAndSaveObject.h"

@interface TableSubjectTopHeaderFooterView : UITableViewHeaderFooterView
@property(nonatomic,strong)IBOutlet UIView *view;

@property(nonatomic,strong)SubjectAndSaveObject *subjectObject;

-(void)setInfoData:(InfoBaseModel *) model;

-(void)rebuildSubject;
@end
