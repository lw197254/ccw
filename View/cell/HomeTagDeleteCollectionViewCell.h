//
//  HomeTagDeleteCollectionViewCell.h
//  chechengwang
//
//  Created by 严琪 on 2017/12/12.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagsModel.h"

@interface HomeTagDeleteCollectionViewCell : UICollectionViewCell
 
@property (weak, nonatomic) IBOutlet UIButton *titlebutton;
@property (weak, nonatomic) IBOutlet UIButton *deletebutton;

-(void)showDeleteButton:(bool) isSelected;

-(void)setTagsModel:(TagsModel *)model;

@end
