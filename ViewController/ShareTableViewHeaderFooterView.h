//
//  ShareTableViewHeaderFooterView.h
//  chechengwang
//
//  Created by 严琪 on 17/1/13.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoBaseModel.h"

@interface ShareTableViewHeaderFooterView : UITableViewHeaderFooterView

@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *shareUrl;
@property(nonatomic,strong)InfoBaseModel *model;
@property(nonatomic,strong)NSString *thumb;

@end
