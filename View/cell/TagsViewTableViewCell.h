//
//  TagsViewTableViewCell.h
//  chechengwang
//
//  Created by 严琪 on 2017/12/11.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagsModel.h"

@interface TagsViewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *fatherView;
@property (strong, nonatomic) NSArray<TagsModel> *tags;

@property (strong, nonatomic) UIColor *color;
@property (assign, nonatomic) bool defaultClick;

- (void)setTagView:(UIView*)tagView titleArray:(NSArray *)titleArr;
@end
