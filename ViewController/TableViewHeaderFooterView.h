//
//  TableViewHeaderFooterView.h
//  chechengwang
//
//  Created by 严琪 on 17/1/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewHeaderFooterView : UITableViewHeaderFooterView

@property (nonatomic,strong) UIImageView *image;
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)UILabel *secondLabel;
@property(nonatomic,assign)bool noimage;
@end
