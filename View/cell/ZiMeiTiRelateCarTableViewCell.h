//
//  ZiMeiTiRelateCarTableViewCell.h
//  chechengwang
//
//  Created by 严琪 on 2017/4/19.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoRelateTypesModel.h"

@interface ZiMeiTiRelateCarTableViewCell : UITableViewCell

-(void)setData:(InfoRelateTypesModel *)model;
-(void)setArtType:(NSString *)arttype;
@end
