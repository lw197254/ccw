//
//  BrandIntroduceViewController.m
//  chechengwang
//
//  Created by 刘伟 on 2016/12/27.
//  Copyright © 2016年 江苏十分便民. All rights reserved.
//

#import "BrandIntroduceViewController.h"
#import "BrandIntroduceViewModel.h"
#import "BrandIntroducerView.h"
@interface BrandIntroduceViewController ()
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (strong, nonatomic) BrandIntroduceViewModel*viewModel;
@property (weak, nonatomic) IBOutlet UIView *seperateLine;
@property (weak, nonatomic) IBOutlet UIView *carSeriesRecommendSuperView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seperateLineConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carSeriesRecommendSuperViewHeightConstraint;
@end

@implementation BrandIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.seperateLine.backgroundColor =BlackColorE3E3E3;
    self.seperateLineConstraint.constant = lineHeight;
    self.viewModel= [BrandIntroduceViewModel SceneModel];
    self.viewModel.request.pinpaiId = self.brandId;
    [self showNavigationTitle:self.brandName];
    self.viewModel.request.startRequest = YES;
    @weakify(self);
    [[RACObserve(self.viewModel, model)filter:^BOOL(id value) {
        @strongify(self);
        return self.viewModel.model.isNotEmpty;
    }]subscribeNext:^(id x) {
        @strongify(self);
        self.introduceLabel.text = self.viewModel.model.brand_story;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        float linespace = 10;
        
        
        paragraphStyle.lineSpacing = linespace;// 字体的行间距
        
        paragraphStyle.headIndent = 0;
       
        
        NSDictionary *attributes = @{
                                     NSFontAttributeName:self.introduceLabel.font,
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        self.introduceLabel.attributedText = [[NSAttributedString alloc] initWithString:self.introduceLabel.text attributes:attributes];
        if (self.viewModel.model.brand_cars.count > 0) {
            BrandIntroducerView*view = [[BrandIntroducerView alloc]initWithFrame:CGRectMake(0, 0, kwidth, 270)];
            view.seeothers = self.viewModel.model.brand_cars;
            [self.carSeriesRecommendSuperView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.carSeriesRecommendSuperView).with.offset(10);
                make.left.right.bottom.equalTo(self.carSeriesRecommendSuperView);
                make.height.mas_equalTo(270);
                
            }];
            self.carSeriesRecommendSuperView.hidden = NO;
        }
        
        
        
    }];
 
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
