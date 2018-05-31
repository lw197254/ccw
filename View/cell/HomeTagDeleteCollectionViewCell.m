//
//  HomeTagDeleteCollectionViewCell.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/12.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "HomeTagDeleteCollectionViewCell.h"

#import "SubjectViewController.h"
#import "CarDeptViewController.h"
#import "TagsViewController.h"

@interface HomeTagDeleteCollectionViewCell()

@property (nonatomic,copy) TagsModel *model;
@end

@implementation HomeTagDeleteCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.titlebutton setBackgroundImage:[UIImage imageWithColor:WhiteColorF6F6F6 size:self.titlebutton.size] forState:UIControlStateNormal];
    [self.titlebutton setBackgroundImage:[UIImage imageWithColor:BlueColorE0ECFF size:self.titlebutton.size] forState:UIControlStateSelected];
    
    //保证所有touch事件button的highlighted属性为NO,即可去除高亮效果
    [self.titlebutton addTarget:self action:@selector(preventFlicker:) forControlEvents:UIControlEventAllTouchEvents];
    [self.titlebutton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
     UILongPressGestureRecognizer *longHandle =  [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTapAction:)];
    
    [self.titlebutton addGestureRecognizer:longHandle];
    
    [self.deletebutton setHidden:YES];
 
}

- (void)longTapAction:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        NSLog(@"long pressTap state :begin");
    }else {
        NSLog(@"long pressTap state :end");
    }
}

-(void)showDeleteButton:(bool)isSelected{
    [self.deletebutton setHidden:isSelected];
}

- (IBAction)deleteButtonClick:(UIButton *)sender {
    
}

- (void)preventFlicker:(UIButton *)button {
    button.highlighted = NO;
}

-(void)setTagsModel:(TagsModel *)model{
    self.model= model;
}

-(void)buttonClick:(UIButton *)button{
    
    if (![button.titleLabel.text isEqualToString:@"全部"]) {
        button.selected = !button.selected;
        if ([self.model.type isEqualToString:@"2"]) {
            CarDeptViewController *vc = [[CarDeptViewController alloc] init];
            vc.chexiid = self.model.car_brand_type_ids;
            [[Tool currentViewController].rt_navigationController pushViewController:vc animated:YES complete:^(BOOL finished) {
                button.selected = !button.selected;
            }];
        }else{
            SubjectViewController*vc = [[SubjectViewController alloc]init];
            vc.id =  self.model.id;
            [[Tool currentViewController].rt_navigationController pushViewController:vc animated:YES complete:^(BOOL finished) {
                button.selected = !button.selected;
            }];
        
        }
       return ;
    }
    

    TagsViewController *vc = [[TagsViewController alloc]init];
    [[Tool currentViewController].rt_navigationController pushViewController:vc animated:YES];
}

@end
