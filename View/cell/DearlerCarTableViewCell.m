//
//  DearlerCarTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 17/3/3.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "DearlerCarTableViewCell.h"
#import "PromotionSaleCarsViewController.h"

#import "DealerDetailViewController.h"
#import "CarTypeDetailViewController.h"
#import "ReducePriceListViewController.h"

@interface DearlerCarTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@end

@implementation DearlerCarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(PromotionDearInfoModel *)model{
    [self.image setImageWithURL:[NSURL URLWithString:model.pic_url] placeholderImage:[UIImage imageNamed:@"默认图片80_60.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.title.text = model.name;
    
    if ([model.orderrange isNotEmpty]) {
        self.label1.text = [NSString stringWithFormat:@" %@ ",model.orderrange];
        [self.label1 setBackgroundColor:OrangeColorFF8844];
        
        if([model.scopestatus isEqualToString:@"1"]){
            self.label2.text = @" 4S店 ";
        }else{
            self.label2.text = @" 综合店 ";
        }
        
        [self.label2 setBackgroundColor:OrangeColorFF8844];
    }else{
        if([model.scopestatus isEqualToString:@"1"]){
            self.label1.text = @" 4S店 ";
        }else{
            self.label1.text = @" 综合店 ";
        }
        
        [self.label1 setBackgroundColor:OrangeColorFF8844];

        self.label2.hidden = YES;
    }
    
    
    

}

- (IBAction)toShop:(id)sender {

    
    NSArray*array = [Tool currentNavigationController ].rt_viewControllers;

    
    
    
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[DealerDetailViewController class]]) {
           [[Tool currentNavigationController].rt_navigationController popToViewController:obj animated:YES];
                 *stop = YES;
        }
        
        //车系跳转过来出现的问题
        if ([obj isKindOfClass:[CarTypeDetailViewController class]]) {
            DealerDetailViewController *contoller = [[DealerDetailViewController alloc] init];
            contoller.dealerId = self.dealer;
            [[Tool currentNavigationController ].rt_navigationController pushViewController:contoller animated:YES];
            *stop = YES;
        }
        
        //降价排行过来的
        if ([obj isKindOfClass:[ReducePriceListViewController class]]) {
            DealerDetailViewController *contoller = [[DealerDetailViewController alloc] init];
            contoller.dealerId = self.dealer;
            [[Tool currentNavigationController ].rt_navigationController pushViewController:contoller animated:YES];
            *stop = YES;
        }
    }];
    
}
- (IBAction)toCar:(id)sender {
    PromotionSaleCarsViewController *vc= [[PromotionSaleCarsViewController alloc] init];
    vc.dealer = self.dealer;
    [URLNavigation pushViewController:vc animated:YES];
}

@end
