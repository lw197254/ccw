//
//  ZiMeiTiRelateCarTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 2017/4/19.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "ZiMeiTiRelateCarTableViewCell.h"
#import "AskForPriceNewViewController.h"

@interface ZiMeiTiRelateCarTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *carname;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property(nonatomic,strong)InfoRelateTypesModel *model;
@property (weak, nonatomic) IBOutlet UIButton *askForPriceButton;


@property (copy, nonatomic) NSString *type;
@end

@implementation ZiMeiTiRelateCarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.askForPriceButton setNormalAskForPriceButton];
    if(kwidth <=320){
        self.price.font = FontOfSize(14);
    }
    
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.image.mas_width).multipliedBy(imageHeightAspectWidth);
    }];
    self.image.clipsToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(InfoRelateTypesModel *)model{
    self.model = model;
    
    [self.image setImageWithURL:[NSURL URLWithString:model.picurl] placeholderImage:[UIImage imageNamed:@"默认图片80_60.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.carname.text = model.name;
    self.price.text = model.zhidaoprice;
}

-(void)setArtType:(NSString *)arttype{
    self.type = arttype;
}

- (IBAction)buttonClick:(id)sender {
    if ([self.type isEqualToString: zimeiti]) {
          [ClueIdObject setClueId:xunjia_123];
    }else{
          [ClueIdObject setClueId:xunjia_11];
    }
    
  
    AskForPriceNewViewController *vc = [[AskForPriceNewViewController alloc] init];
    vc.carSerieasId = self.model.typeid;
    vc.imageUrl = self.model.picurl;
    [URLNavigation pushViewController:vc animated:YES];
}

@end
