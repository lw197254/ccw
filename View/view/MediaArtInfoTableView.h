//
//  MediaArtInfoTableView.h
//  chechengwang
//
//  Created by 严琪 on 2017/9/30.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoBaseModel.h"
#import "TableSubjectTopHeaderFooterView.h"
@interface MediaArtInfoTableView : UITableView

@property (nonatomic,strong) TableSubjectTopHeaderFooterView *headview;
@property (nonatomic,copy)NSMutableArray *commitList;
@property(nonatomic,copy)InfoBaseModel *data;

-(void)setMediaData:(InfoBaseModel *)data;





@end
