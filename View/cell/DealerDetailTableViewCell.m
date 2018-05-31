//
//  DealerDetailTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 17/3/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "DealerDetailTableViewCell.h"

@interface DealerDetailTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *oldprice;

@end

@implementation DealerDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bottomLineShow = YES;
    
    
    [self setBottomLineWithEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.image.mas_width).multipliedBy(imageHeightAspectWidth);
    }];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setData:(PromotionCarModel *)model{
    [self.image setImageWithURL:[NSURL URLWithString:model.picurl] placeholderImage:[UIImage imageNamed:@"默认图片80_60.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    NSString *carn = [NSString stringWithFormat:@"%@ %@",model.typename,model.carname];
    self.title.text =carn;
    
    
    if ([model.showprice isEqualToString:@"0.00"]||model.showprice.length==0) {
        self.price.text = @"暂无报价";
    }else{
        NSString *price = [NSString stringWithFormat:@"￥%@万",model.showprice];
        self.price.text = price;
    }
    
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@万",model.facprice]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    
    self.oldprice.attributedText = newPrice;
}
@end
