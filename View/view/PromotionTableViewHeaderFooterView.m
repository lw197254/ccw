//
//  PromotionTableViewHeaderFooterView.m
//  chechengwang
//
//  Created by 严琪 on 17/3/6.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "PromotionTableViewHeaderFooterView.h"
#import "PromotionSaleCarTableViewCell.h"
#import "PromotionCarList.h"

#import "CarDeptTableViewHeaderFooterView.h"
#import "TableViewFooterView.h"
#import "PromotionMoreTableViewHeaderFooterView.h"


@interface PromotionTableViewHeaderFooterView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *carTypes;
@property (weak, nonatomic) IBOutlet UILabel *price;

//保存对应的section的值
@property(nonatomic,assign)NSInteger sectionCount;


@end

@implementation PromotionTableViewHeaderFooterView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [[NSBundle mainBundle]loadNibNamed:@"PromotionTableViewHeaderFooterView" owner:self options:nil];
        [self addSubview:self.view];
        
        [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}
- (IBAction)buttonClick:(id)sender {

}

-(void)setData:(PromotionSaleCarModel *)model Count:(NSInteger)section{
    PromotionTypeInfoModel *car = model.typeinfo[section];
    
    [self.imageView setImageWithURL:[NSURL URLWithString:car.picurl] placeholderImage:[UIImage imageNamed:@"默认图片80_60.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.title.text = car.typename;
    
    NSString *info = [NSString stringWithFormat:@"共%@款车型",car.carnum];
    self.carTypes.text = info;
    
    NSString *price = [NSString stringWithFormat:@"¥%@万",car.price];
    self.price.text =price;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
