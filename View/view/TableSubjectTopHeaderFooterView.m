//
//  TableSubjectTopHeaderFooterView.m
//  chechengwang
//
//  Created by 严琪 on 17/4/10.
//  Copyright © 2017年 江苏十分便民. All rights reserved.
//

#import "TableSubjectTopHeaderFooterView.h"
#import "SubjectUserModel.h"

#import "SubscribeDetailViewController.h"
#import "LoginViewController.h"
#import "ShadowLoginViewController.h"



@interface TableSubjectTopHeaderFooterView()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property(nonatomic,strong) InfoBaseModel * data;
@property(nonatomic,strong)UIView *popView;

@end
@implementation TableSubjectTopHeaderFooterView


-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [[NSBundle mainBundle]loadNibNamed:@"TableSubjectTopHeaderFooterView" owner:self options:nil];
        [self addSubview:self.view];
        
        [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [[NSBundle mainBundle]loadNibNamed:@"TableSubjectTopHeaderFooterView" owner:self options:nil];
        [self addSubview:self.view];
        
        [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
    }
    return self;
}

-(void)setInfoData:(InfoBaseModel *)model{
    self.data = model;
    
    self.title.text = model.title;
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Semibold" size:22];
    
    if (font) {
        [self.title setFont:font];
    }else{
        [self.title setFont:[UIFont fontWithName:@"Helvetica-Bold" size:22]];
    }

    
    self.name.text = model.authorName;
    self.time.text = model.inputtime;
    
    [self.img setImageWithURL:[NSURL URLWithString:model.authorPic] placeholderImage:[UIImage imageNamed:@"pic_head"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    

    self.button.layer.borderWidth =1;
    self.button.layer.cornerRadius = 3;
    self.button.layer.masksToBounds = YES;
    NSArray *browse = [SubjectUserModel findByColumn:@"authorId" value:self
                       .data.authorId];
    if (browse.count==0) {

            self.button.layer.borderColor = BlueColor447FF5.CGColor;
            [self.button setBackgroundColor:[UIColor whiteColor]];
            [self.button setTitle:@"+ 订阅" forState:UIControlStateNormal];
            [self.button setTitleColor:BlueColor447FF5 forState:UIControlStateNormal];
    }else{
            self.button.layer.borderColor = BlackColorEEEEEE.CGColor;
            [self.button setBackgroundColor:[UIColor whiteColor]];
            [self.button setTitle:@"已订阅" forState:UIControlStateNormal];
            [self.button setTitleColor:BlackColorCCCCCC forState:UIControlStateNormal];
    }
}
- (IBAction)buttonClick:(id)sender {
    
    //未登录的时候先登录
    if (![[UserModel shareInstance].uid isNotEmpty]) {
        ShadowLoginViewController *controller = [[ShadowLoginViewController alloc] init];
        [URLNavigation pushViewController:controller animated:YES];
        return;
    }
    
    if([self.button.titleLabel.textColor isEqual:BlueColor447FF5]){
    
        @weakify(self)
        self.subjectObject.subjectBlock = ^(bool isok) {
            if (isok) {
                 self_weak_.button.layer.borderColor = BlackColorEEEEEE.CGColor;
                [self_weak_.button setTitle:@"已订阅" forState:UIControlStateNormal];
                [self_weak_.button setTitleColor:BlackColorCCCCCC forState:UIControlStateNormal];
            }
        };
        
        [self saveSubjectModel:self.data.authorId authorName:self.data.authorName authorPic:self.data.authorPic];
    }else{
        //点击不可以取消
        SubscribeDetailViewController *controller = [[SubscribeDetailViewController alloc] init];
        SubjectUserModel *model = [[SubjectUserModel alloc] init];
        model.authorName = self.data.authorName;
        model.imgurl = self.data.authorPic;
        model.authorId = self.data.authorId;
        
        controller.model = model;
        
        [URLNavigation pushViewController:controller animated:YES];
//        [self.button setBackgroundColor:LightBlueColor];
//        [self.button setTitle:@"+订阅" forState:UIControlStateNormal];
//        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self deleteSubjectModel:self.data.authorId];
    }
}

-(void)saveSubjectModel:(NSString*) authorId authorName:(NSString *)name authorPic:(NSString *)pic{
        SubjectUserModel *model = [[SubjectUserModel alloc] init];
        model.authorId = authorId;
        model.authorName = name;
        model.imgurl = pic;
        [self.subjectObject SubjectSaveObject:model];
}

-(void)deleteSubjectModel:(NSString*) authorId{
    NSArray *subject = [SubjectUserModel findByColumn:@"authorId" value:authorId];
    if ([subject count]) {
        SubjectUserModel *temp = subject[0];
        [temp deleteSelf];
    }
}

-(void)rebuildSubject{
    NSArray *browse = [SubjectUserModel findByColumn:@"authorId" value:self
                       .data.authorId];
    if (browse.count==0) {
        
        self.button.layer.borderColor = BlueColor447FF5.CGColor;
        [self.button setBackgroundColor:[UIColor whiteColor]];
        [self.button setTitle:@"+ 订阅" forState:UIControlStateNormal];
        [self.button setTitleColor:BlueColor447FF5 forState:UIControlStateNormal];
    }else{
        self.button.layer.borderColor = BlackColorEEEEEE.CGColor;
        [self.button setBackgroundColor:[UIColor whiteColor]];
        [self.button setTitle:@"已订阅" forState:UIControlStateNormal];
        [self.button setTitleColor:BlackColorCCCCCC forState:UIControlStateNormal];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
