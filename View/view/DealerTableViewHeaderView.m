//
//  DealerTableViewHeaderView.m
//  chechengwang
//
//  Created by 严琪 on 17/3/2.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "DealerTableViewHeaderView.h"
#import "CarTypeDetailHeaderHTHorizontalButtonView.h"


#define shop @"店铺首页"
#define saleinfo @"促销信息"
#define salecar @"在售车型"
#define companyinfo @"公司信息"


@interface DealerTableViewHeaderView ()
@property (strong, nonatomic) NSArray *hozirontalListArray;

@end
@implementation DealerTableViewHeaderView

-(instancetype)init{
    if(self = [super init]){
        
        self.firstHeadView = [[UIView alloc] init];
        [self.contentView addSubview:self.firstHeadView];
        
        [self.firstHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.left.equalTo(self.contentView);
           
        }];
        
        [self firstHead];
        [self secondHead];
        //[self thridHead];
    }
    return self;
}

-(void)firstHead{
    self.firstImageView = [[UIImageView alloc] init];
    [self.firstHeadView addSubview:self.firstImageView];
    [self.firstHeadView sendSubviewToBack:self.firstImageView];
    
    [self.firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.firstHeadView);
    }];
    
    self.headImage = [[UIImageView alloc] init];
    [self.firstHeadView addSubview:self.headImage];
    
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self.firstHeadView);
    }];
    
    //添加边框
//    self.headImage.layer.masksToBounds = YES;//允许加边框
//    self.headImage.layer.borderWidth = 5;//边框宽度
//    self.headImage.layer.borderColor = [UIColor whiteColor].CGColor;//边框颜
    
    self.shopProperty2 = [[UILabel alloc] init];
    
    [self.firstHeadView addSubview:self.shopProperty2];
   
    self.shopProperty2.font = FontOfSize(11);
    self.shopProperty2.layer.cornerRadius = 2;
    self.shopProperty2.clipsToBounds = YES;
    self.shopProperty2.backgroundColor = [UIColor whiteColor];
    self.shopProperty2.textColor = BlackColor333333;
    

    
    self.shopName = [[UILabel alloc]init];
    self.shopName.numberOfLines = 0;
    [self.firstHeadView addSubview:self.shopName];
    self.shopName.font = [UIFont boldSystemFontOfSize:14];
    self.shopName.textColor = [UIColor whiteColor];
    
    
    self.shopProperty1 = [[UILabel alloc] init];
    [self.firstHeadView addSubview:self.shopProperty1];
    self.shopProperty1.font =FontOfSize(10);
    self.shopProperty1.layer.cornerRadius = 2;
    self.shopProperty1.clipsToBounds = YES;
    self.shopProperty1.textAlignment = NSTextAlignmentCenter;
    
    self.shopProperty1.textColor = [UIColor whiteColor];
    
    
    self.locationImage = [[UIImageView alloc] init];
    [self.firstHeadView addSubview:self.locationImage];
    
    self.location = [[UILabel alloc] init];
    self.location.numberOfLines = 0;
    self.location.font = FontOfSize(12);
    self.location.textColor = [UIColor whiteColor];
   
    [self.firstHeadView addSubview:self.location];
    [self.shopProperty2 setContentHuggingPriority:UILayoutPriorityRequired
                               forAxis:UILayoutConstraintAxisHorizontal];
    [self.shopProperty2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shopName).with.offset(2);
        make.width.mas_equalTo(20);
        make.left.equalTo(self.headImage.mas_right).offset(15);
        
    }];
    [self.shopName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopProperty2.mas_right).offset(8);
        make.top.equalTo(self.headImage);
        make.right.equalTo(self.firstHeadView).with.offset(-15);
        
    }];
    
    [self.shopProperty1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstHeadView).offset(10);
        make.right.equalTo(self.firstHeadView).offset(-10);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(35);
    }];
    
    [self.locationImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.location).with.offset(2);
        make.left.equalTo(self.shopProperty2);
        
        make.height.mas_equalTo(10);
        make.width.mas_equalTo(8);
    }];

    [self.location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shopName.mas_bottom).with.offset(10);
        make.left.equalTo(self.locationImage.mas_right).with.offset(2);
        make.right.equalTo(self.firstHeadView).with.offset(-15);
        make.bottom.equalTo(self.firstHeadView).with.offset(-30).priority(100);
    }];
   
    
}

-(void)secondHead{
    self.secondHeadView = [[UIView alloc] init];
    [self.contentView addSubview: self.secondHeadView];
    [self.secondHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.top.equalTo(self.firstHeadView.mas_bottom);
        make.height.mas_equalTo(90);
        
    }];
    
    self.horizontalSelectionList = [[HTHorizontalSelectionList alloc] init];
    [self addSubview:self.horizontalSelectionList];
    [self.horizontalSelectionList mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.equalTo(self);
        make.top.equalTo(self.secondHeadView);
        make.height.mas_equalTo(78);
    }];
    
    self.horizontalSelectionList.dataSource = self;
    self.horizontalSelectionList.selectionIndicatorStyle = HTHorizontalSelectionIndicatorStyleNone;
    self.horizontalSelectionList.maxShowCount = 4;
    self.horizontalSelectionList.minShowCount = 4;
    
    //最后的一根线
    UIView *view = [[UIView alloc]init];
    [self.secondHeadView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.horizontalSelectionList.mas_bottom);
        make.right.left.equalTo(self);
        make.height.mas_equalTo(10);
    }];
    [view setBackgroundColor:BlackColorF1F1F1];
}

-(void)thridHead{
    self.thridHeadView = [[UIView alloc] init];
    [self addSubview:self.thridHeadView];
    [self.thridHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondHeadView);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(180);
    }];
    
    self.bigImageView = [[UIImageView alloc]init];
    [self.thridHeadView addSubview:self.bigImageView];
    [self.bigImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.thridHeadView);
    }];
    
    self.info = [[UILabel alloc]init];
    [self.thridHeadView addSubview:self.info];
    [self.info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.thridHeadView);
        make.height.mas_equalTo(25);
    }];
}


-(NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList{
    return self.hozirontalListArray.count;
}

-(NSArray*)hozirontalListArray{
    if (!_hozirontalListArray) {
        _hozirontalListArray = @[@{@"title":salecar,@"imageName":salecar},
                                 @{@"title":saleinfo,@"imageName":saleinfo},
                                 
                                 @{@"title":companyinfo,@"imageName":companyinfo}];
    }
    return _hozirontalListArray;
}



-(UIView *)selectionList:(HTHorizontalSelectionList *)selectionList viewForItemWithIndex:(NSInteger)index{
    CarTypeDetailHeaderHTHorizontalButtonView*view = [[[NSBundle mainBundle]loadNibNamed:classNameFromClass(CarTypeDetailHeaderHTHorizontalButtonView) owner:nil options:nil]firstObject];
    NSDictionary*dict = self.hozirontalListArray[index];
    view.imageView.image = [UIImage imageNamed:dict[@"imageName"]];
    if ([dict[@"title"] isEqualToString:shop]) {
        view.titleLabel.text = dict[@"title"];
        view.titleLabel.textColor  = BlackColor333333;
    }else{
        view.titleLabel.text = dict[@"title"];
        view.titleLabel.textColor  = BlackColor333333;
    }
    return view;

}

-(void)setHeadData:(PromotionDearInfoModel *)model{
    [self.headImage setImageWithURL:[NSURL URLWithString:model.pic_url] placeholderImage:[UIImage imageNamed:@"默认图片80_60.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.shopName.text = model.name;
    self.location.text = model.address;
    
 
    self.shopProperty1.text = model.orderrange;
    
    self.shopProperty1.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.shopProperty1.layer.borderWidth = 0.5f;
    self.shopProperty1.layer.masksToBounds = YES;
    
    if([model.scopestatus isEqualToString:@"1"]){
        self.shopProperty2.text = @"4S";
    }else{
        self.shopProperty2.text = @"综合";
    }
    
    self.shopProperty2.textAlignment = NSTextAlignmentCenter;
    self.shopProperty2.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.shopProperty2.layer.borderWidth = 0.5f;
    self.shopProperty2.layer.masksToBounds = YES;
    
    
    [self.locationImage setImage:[UIImage imageNamed:@"定位小"]];
    [self.firstImageView setImage:[UIImage imageNamed:@"ditu"]];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
