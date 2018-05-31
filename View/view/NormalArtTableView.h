//
//  NormalArtTableView.h
//  chechengwang
//
//  Created by 严琪 on 2017/9/30.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoBaseModel.h"



typedef void(^scrollView2FatherView)(UIScrollView *srollview);
@interface NormalArtTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,copy)InfoBaseModel *data;
@property(nonatomic,copy)scrollView2FatherView block;

-(void)setMediaData:(InfoBaseModel *)data;

@end
