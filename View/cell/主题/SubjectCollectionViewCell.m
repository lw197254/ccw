//
//  SubjectCollectionViewCell.m
//  chechengwang
//
//  Created by 严琪 on 2017/12/13.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "SubjectCollectionViewCell.h"
#import "AskForPriceNewViewController.h"

@interface SubjectCollectionViewCell()

@property(nonatomic,copy) SubjectChexiModel *model;
@end

@implementation SubjectCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setSubjectModel:(SubjectChexiModel *)model{
    self.model = model;
}

- (IBAction)askButton:(id)sender {
    [ClueIdObject setClueId: xunjia_170];
    
    AskForPriceNewViewController *vc = [[AskForPriceNewViewController alloc] init];
//    vc.carTypeName = self.model.car_model_name;
    vc.carSerieasId = self.model.car_brand_type_id;
    vc.imageUrl = self.model.picture.bigpic;
    [[Tool currentViewController].rt_navigationController pushViewController:vc animated:YES];
    
}


@end
