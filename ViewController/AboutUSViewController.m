//
//  AboutUSViewController.m
//  chechengwang
//
//  Created by 严琪 on 17/2/20.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "AboutUSViewController.h"

@interface AboutUSViewController ()
@property (weak, nonatomic) IBOutlet UILabel *aboutus;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation AboutUSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"关于我们"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"版本 V%@",version];
    
   NSString *info = @"  南京车城网络科技有限公司，2015年9月创立，是车城控股股份有限公司旗的专业汽车营销服务平台。秉承“共享共融，开放平台”原则，车城汇聚行业精锐，线上线下联动发展，全面布局，旨在打造一个汽车资讯与汽车服务并举的开放平台，为汽车消费者提供选车、买车、用车、换车等全方位、第一手、最实用的一站式服务。目前，车城网拥有数百家战略合作伙伴，媒体覆盖全国7大区域，并与360搜索、滴滴、携程达成战略合作关系。";
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    self.aboutus.numberOfLines = 0;
    paragraphStyle.headIndent = 0;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:self.aboutus.font,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    self.aboutus.attributedText = [[NSAttributedString alloc] initWithString:info attributes:attributes];
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
