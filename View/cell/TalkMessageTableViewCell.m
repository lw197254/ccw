//
//  TalkMessageTableViewCell.m
//  chechengwang
//
//  Created by 严琪 on 2017/8/17.
//  Copyright © 2017年 车城网. All rights reserved.
//

#import "TalkMessageTableViewCell.h"

static NSString *LEFT = @"left";
static NSString *RIGHT = @"right";

@interface TalkMessageTableViewCell()

@property (nonatomic,strong) CommiteModel *currentModel;
@property (nonatomic,strong)UIView *tagView;
 
@end

@implementation TalkMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.leftheadimage.layer.cornerRadius=self.leftheadimage.frame.size.width/2;//裁成圆角
    self.leftheadimage.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    
    self.rightheadimage.layer.cornerRadius=self.rightheadimage.frame.size.width/2;//裁成圆角
    self.rightheadimage.layer.masksToBounds=YES;//隐藏裁剪掉的部分
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setMessageData:(CommiteModel *)model{
   
    [self.currentlabelleft setHidden:YES];
    [self.currentLabel setHidden:YES];
    
    
    if ([model.position isEqualToString:LEFT])
    {
        
        [self.leftheadimage setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"我的默认头像.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        NSString *time = [@" " stringByAppendingString:model.formataddtime];
        self.leftname.text = [model.username stringByAppendingString:time];
        
        
        ///kwidth-69*2  表示当前label占用的最大宽度
      CGSize size =  [self getSizeByString:model.content width:kwidth-69*2  AndFontSize:self.content.font.pointSize];
        [self.content mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(size.height);
        }];
        self.content.text = model.content;
       
        [self.contentright setHidden:YES];
        
        
        if ([model.id isEqualToString:self.currentModel.id]) {
            [self.currentlabelleft setHidden:NO];
            self.leftContentBackgroundImageBottomTosuperConstraints.constant = 33;
        }else{
            [self.currentlabelleft setHidden:YES];
            self.leftContentBackgroundImageBottomTosuperConstraints.constant = 15;
        }
         self.leftContentBackgroundImageBottomTosuperConstraints.priority = 300;
        self.rightContentBackgroundImageBottomTosuperConstraints.priority = 100;
        
//        CGFloat top = 10; // 顶端盖高度
//        CGFloat bottom = 10 ; // 底端盖高度
//        CGFloat left = 0; // 左端盖宽度
//        CGFloat right = 10; // 右端盖宽度
//        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
//        // 伸缩后重新赋值
//        image = [image resizableImageWithCapInsets:insets];
        [self.leftContentBackgroundImageView setImage: [[UIImage imageNamed:@"蓝色"] stretchableImageWithLeftCapWidth:15 topCapHeight:30]];
        [self.rightheadimage setHidden:YES];
        [self.rightname setHidden:YES];
        
        
        
        
    }else{
        [self.rightheadimage setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"我的默认头像.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        NSString *name = [@" " stringByAppendingString:@"我"];
        self.rightname.text = [model.formataddtime stringByAppendingString:name];
        CGSize size =  [self getSizeByString:model.content width:kwidth-69*2  AndFontSize:self.content.font.pointSize];
        [self.contentright mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(size.height);
        }];
        self.contentright.text = model.content;
        
        [self.rightContentBackgroundImageView setImage:[[UIImage imageNamed:@"灰色"] stretchableImageWithLeftCapWidth:15 topCapHeight:30] ];
//        self.contentright.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0,30);
        
        [self.leftheadimage setHidden:YES];
        [self.leftname setHidden:YES];
        [self.content setHidden:YES];
        
        
        if ([model.id isEqualToString:self.currentModel.id]) {
            [self.currentLabel setHidden:NO];
            self.rightContentBackgroundImageBottomTosuperConstraints.constant = 33;
        }else{
            [self.currentLabel setHidden:YES];
            self.rightContentBackgroundImageBottomTosuperConstraints.constant = 15;
        }
        self.leftContentBackgroundImageBottomTosuperConstraints.priority = 100;
        self.rightContentBackgroundImageBottomTosuperConstraints.priority = 300;
       
    }
    
    

}

-(void)setCurrentData:(CommiteModel *)model{
    self.currentModel = model;
}

//- (void)initView:(NSArray *)titleArr{
//    self.tagView= [[UIView alloc]initWithFrame:CGRectZero];
//    //第一个 label的起点
//    CGSize size = CGSizeMake(5, 38);
//    //间距
//    CGFloat padding = 5.0;
//    CGFloat leftPadding = 10;
//    CGFloat rightPadding = 10;
//    CGFloat width = [UIScreen                                                                       mainScreen].bounds.size.width-(leftPadding+rightPadding);
//
//    for (int i = 0; i < titleArr.count; i ++) {
//
//        CGFloat keyWorldWidth = [self getSizeByString:titleArr[i] AndFontSize:14].width+14;
//        if (keyWorldWidth > width) {
//            keyWorldWidth = width;
//        }
//        if (width - size.width < keyWorldWidth) {
//            size.height += 38.0;
//            size.width = 5.0;
//        }
//
//        if (width - size.width < 100) {
//            size.height += 38.0;
//            size.width = 5.0;
//        }
//        //创建 label点击事件
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame =CGRectMake(size.width, size.height-38, keyWorldWidth, 28);
//        button.titleLabel.numberOfLines = 0;
//        UIImage *image = [UIImage imageNamed:@"bnt_xundijia_n.png"];
//        //UIImage*newImage = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
//        [button setBackgroundImage: [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2] forState:UIControlStateNormal];
//        [button setTitleColor:BlueColor447FF5 forState:UIControlStateNormal];
//        //        button.layer.cornerRadius = 3.0;
//        //        button.layer.masksToBounds = YES;
//        button.titleLabel.font = FontOfSize(14);
//        button.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [button setTitle:titleArr[i] forState:UIControlStateNormal];
//        [self.tagView addSubview:button];
//        button.tag = i;
//        //起点 增加
//        size.width += keyWorldWidth+padding;
//
//    }
//
////    [self.tagView mas_remakeConstraints:^(MASConstraintMaker *make) {
////        make.height.mas_equalTo(size.height);
////        make.left.equalTo(self.contentView).offset(leftPadding);
////        make.right.equalTo(self.contentView.mas_right).offset(-rightPadding);
////        make.top.equalTo(self.contentView.mas_top).offset(3);
////        make.bottom.equalTo(self.contentView.mas_bottom);
////    }];
//
//}
////计算文字所占大小
- (CGSize)getSizeByString:(NSString*)string width:(CGFloat)width AndFontSize:(CGFloat)font
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, 9999) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:FontOfSize(font)} context:nil].size;
    size.height += 5;
    return size;
}

//-(void)setData:(NSString *)info{
//    NSArray *array = [info componentsSeparatedByString:@","];
//    [self initView:array];
//}

@end
